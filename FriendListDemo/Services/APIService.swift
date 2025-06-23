import Foundation
import Combine

enum APIError: Error {
    case invalidURL
    case networkError(Error)
    case decodingError(Error)
}

class APIService {
    static let shared = APIService()
    private init() {}
    
    private let baseURL = "https://dimanyen.github.io"
    private let logger = Logger(tag: "APIService", defaultLevel: .info)
    
    /// 獲取使用者資料
    func fetchUserData() -> AnyPublisher<User, APIError> {
        return fetchData(endpoint: "/man.json")
    }
    
    /// 獲取好友列表1
    func fetchFriendList1() -> AnyPublisher<FriendListResponse, APIError> {
        return fetchData(endpoint: "/friend1.json")
    }
    
    /// 獲取好友列表2
    func fetchFriendList2() -> AnyPublisher<FriendListResponse, APIError> {
        return fetchData(endpoint: "/friend2.json")
    }
    
    /// 獲取好友列表含邀請
    func fetchFriendListWithInvitations() -> AnyPublisher<FriendListResponse, APIError> {
        return fetchData(endpoint: "/friend3.json")
    }
    
    /// 獲取無資料邀請/好友列表
    func fetchEmptyFriendList() -> AnyPublisher<FriendListResponse, APIError> {
        return fetchData(endpoint: "/friend4.json")
    }
    
    /// 通用資料獲取方法
    private func fetchData<T: Decodable>(endpoint: String) -> AnyPublisher<T, APIError> {
        guard let url = URL(string: baseURL + endpoint) else {
            logger.log("Invalid URL: \(baseURL + endpoint)", level: .error)
            return Fail(error: APIError.invalidURL).eraseToAnyPublisher()
        }
        logger.log("Request: \(url)")
        return URLSession.shared.dataTaskPublisher(for: url)
            .handleEvents(receiveOutput: { data, _ in
                if let str = String(data: data, encoding: .utf8) {
                    self.logger.log("Response for \(url):\n\(str)", level: .debug)
                }
            }, receiveCompletion: { completion in
                if case .failure(let error) = completion {
                    self.logger.log("Error for \(url): \(error)", level: .error)
                }
            })
            .mapError { APIError.networkError($0) }
            .map { $0.data }
            .decode(type: T.self, decoder: JSONDecoder())
            .mapError { APIError.decodingError($0) }
            .eraseToAnyPublisher()
    }
} 