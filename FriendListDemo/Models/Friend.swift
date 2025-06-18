import Foundation

/// 好友資料模型
struct Friend: Codable {
    /// 好友姓名
    let name: String
    
    /// 好友狀態
    /// - 0: 邀請送出
    /// - 1: 已完成
    /// - 2: 邀請中
    let status: Int
    
    /// 是否為置頂好友
    /// - "0": 非置頂
    /// - "1": 置頂（會顯示星星標記）
    let isTop: String
    
    /// 好友唯一識別碼
    let fid: String
    
    /// 資料更新時間
    /// 支援兩種格式：
    /// - YYYYMMDD (例如：20190801)
    /// - YYYY/MM/DD (例如：2019/08/02)
    private let updateDateString: String
    
    /// 標準化的日期字串（YYYYMMDD 格式）
    var updateDate: String {
        // 如果包含斜線，則為 YYYY/MM/DD 格式
        if updateDateString.contains("/") {
            return updateDateString.replacingOccurrences(of: "/", with: "")
        }
        
        // 否則為 YYYYMMDD 格式
        return updateDateString
    }
    
    enum CodingKeys: String, CodingKey {
        case name
        case status
        case isTop
        case fid
        case updateDateString = "updateDate"
    }
}

/// 好友列表回應模型
struct FriendListResponse: Codable {
    /// 好友列表資料陣列
    let response: [Friend]
} 