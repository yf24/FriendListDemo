import Foundation

/// 使用者資料模型
struct User: Codable {
    /// 使用者姓名
    let name: String
    
    /// 使用者 KOKO ID
    let kokoid: String
    
    enum CodingKeys: String, CodingKey {
        case name
        case kokoid
    }
} 