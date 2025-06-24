import Foundation

extension UInt64 {
    static func milliseconds(_ ms: Int) -> UInt64 {
        return UInt64(ms) * 1_000_000
    }
    static func seconds(_ s: Int) -> UInt64 {
        return UInt64(s) * 1_000_000_000
    }
} 