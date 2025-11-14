import Foundation

enum LogLevel: String {
    case debug = "🐛"
    case info = "ℹ️"
    case warning = "⚠️"
    case error = "❌"
}

struct Logger {
    let tag: String
    let defaultLevel: LogLevel
    static let shared = Logger(tag: "GLOBAL")
    private static let maxLogCount = 500
    private static var logBuffer: [String] = []
    private static let bufferQueue = DispatchQueue(label: "LoggerBufferQueue")
    static let logDidUpdateNotification = Notification.Name("LoggerLogDidUpdate")

    init(tag: String, defaultLevel: LogLevel = .info) {
        self.tag = tag
        self.defaultLevel = defaultLevel
    }

    func log(_ message: String, level: LogLevel? = nil, file: String = #file, function: String = #function, line: Int = #line) {
        #if DEBUG
        let fileName = (file as NSString).lastPathComponent
        let timestamp = Logger.timestamp()
        let thread = Thread.isMainThread ? "Main" : "BG"
        let tagPart = tag.isEmpty ? "" : "[\(tag)] "
        let logString = "\((level ?? defaultLevel).rawValue) \(timestamp) [\(thread)] \(fileName):\(line) \(function) \(tagPart)\(message)"
        print(logString)
        Logger.bufferQueue.sync {
            if Logger.logBuffer.count >= Logger.maxLogCount {
                Logger.logBuffer.removeFirst()
            }
            Logger.logBuffer.append(logString)
        }
        NotificationCenter.default.post(name: Logger.logDidUpdateNotification, object: nil)
        #endif
    }

    static func getLogBuffer() -> [String] {
        return bufferQueue.sync { logBuffer }
    }

    static func clearLogBuffer() {
        bufferQueue.sync {
            logBuffer.removeAll()
        }
        NotificationCenter.default.post(name: Logger.logDidUpdateNotification, object: nil)
    }

    private static func timestamp() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss.SSS"
        return formatter.string(from: Date())
    }
} 