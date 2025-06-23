import Foundation

/// 使用者資料模型
struct User: Codable {
    /// 使用者姓名
    let name: String
    
    /// 使用者 KOKO ID（可為空）
    let kokoid: String?
    
    enum CodingKeys: String, CodingKey {
        case name
        case kokoid
    }
} 

struct UserResponse: Codable {
    let response: [User]
} 
