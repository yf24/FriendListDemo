import Foundation

extension Date {
    static func from(_ yyyymmdd: String) -> Date {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyyMMdd"
        formatter.locale = Locale(identifier: "en_US_POSIX")
        return formatter.date(from: yyyymmdd) ?? Date(timeIntervalSince1970: 0)
    }
} 