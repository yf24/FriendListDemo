import Foundation

/// 好友狀態
enum FriendStatus: Int, Codable {
    case invitedSent = 0   // 邀請送出
    case completed = 1     // 已完成
    case inviting = 2      // 邀請中
}

/// 好友資料模型
struct Friend: Codable {
    /// 好友姓名
    let name: String
    /// 好友狀態
    let status: FriendStatus
    /// 是否為置頂好友
    let isTop: Bool
    /// 好友唯一識別碼
    let fid: String
    /// 資料更新時間（Date 型別，已自動處理格式）
    let updateDate: Date
    
    enum CodingKeys: String, CodingKey {
        case name
        case status
        case isTop
        case fid
        case updateDate = "updateDate"
    }
    // internal init for mock/testing
    init(name: String, status: FriendStatus, isTop: Bool, fid: String, updateDateString: String) {
        self.name = name
        self.status = status
        self.isTop = isTop
        self.fid = fid
        self.updateDate = Friend.parseDate(updateDateString)
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        name = try container.decode(String.self, forKey: .name)
        status = try container.decode(FriendStatus.self, forKey: .status)
        let isTopString = try container.decode(String.self, forKey: .isTop)
        isTop = (isTopString == "1")
        fid = try container.decode(String.self, forKey: .fid)
        let updateDateString = try container.decode(String.self, forKey: .updateDate)
        updateDate = Friend.parseDate(updateDateString)
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(name, forKey: .name)
        try container.encode(status, forKey: .status)
        try container.encode(isTop ? "1" : "0", forKey: .isTop)
        try container.encode(fid, forKey: .fid)
        // encode 時轉回 yyyyMMdd 字串
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyyMMdd"
        formatter.locale = Locale(identifier: "en_US_POSIX")
        let dateString = formatter.string(from: updateDate)
        try container.encode(dateString, forKey: .updateDate)
    }

    /// 處理 yyyy/MM/dd 或 yyyyMMdd 兩種格式
    private static func parseDate(_ str: String) -> Date {
        let cleaned = str.replacingOccurrences(of: "/", with: "")
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyyMMdd"
        formatter.locale = Locale(identifier: "en_US_POSIX")
        return formatter.date(from: cleaned) ?? Date(timeIntervalSince1970: 0)
    }
}

/// 好友列表回應模型
struct FriendListResponse: Codable {
    /// 好友列表資料陣列
    let response: [Friend]
} 