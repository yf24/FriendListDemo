import Foundation
import Combine

enum FriendListState {
    case empty
    case friendsOnly
    case friendsWithInvitations
}

class FriendPageViewModel {
    // MARK: - Published Properties
    @Published var user: User?
    @Published var friends: [Friend] = []
    @Published var invitations: [Friend] = []
    @Published var filteredFriends: [Friend] = []
    @Published var isLoading: Bool = false
    @Published var error: APIError?
    @Published var currentState: FriendListState = .empty
    @Published var searchText: String = ""
    
    // MARK: - Private Properties
    private var cancellables = Set<AnyCancellable>()
    private let apiService = APIService.shared
    
    // MARK: - Initialization
    init() {
        setupSearchBinding()
    }
    
    // MARK: - Public Methods
    func loadData(for state: FriendListState) {
        isLoading = true
        currentState = state
        
        // 先載入使用者資料
        apiService.fetchUserData()
            .sink(receiveCompletion: { [weak self] completion in
                if case .failure(let error) = completion {
                    self?.error = error
                }
            }, receiveValue: { [weak self] user in
                self?.user = user
            })
            .store(in: &cancellables)
        
        // 根據狀態載入不同的好友列表
        switch state {
        case .empty:
            loadEmptyState()
        case .friendsOnly:
            loadFriendsOnlyState()
        case .friendsWithInvitations:
            loadFriendsWithInvitationsState()
        }
    }
    
    // MARK: - Private Methods
    private func setupSearchBinding() {
        $searchText
            .debounce(for: .milliseconds(300), scheduler: RunLoop.main)
            .sink { [weak self] searchText in
                self?.filterFriends(with: searchText)
            }
            .store(in: &cancellables)
    }
    
    private func filterFriends(with searchText: String) {
        if searchText.isEmpty {
            filteredFriends = friends
        } else {
            filteredFriends = friends.filter { $0.name.localizedCaseInsensitiveContains(searchText) }
        }
    }
    
    private func loadEmptyState() {
        apiService.fetchEmptyFriendList()
            .sink(receiveCompletion: { [weak self] completion in
                if case .failure(let error) = completion {
                    self?.error = error
                }
                self?.isLoading = false
            }, receiveValue: { [weak self] response in
                self?.friends = response.response
                self?.filteredFriends = response.response
                self?.isLoading = false
            })
            .store(in: &cancellables)
    }
    
    private func loadFriendsOnlyState() {
        Publishers.Zip(apiService.fetchFriendList1(), apiService.fetchFriendList2())
            .sink(receiveCompletion: { [weak self] completion in
                if case .failure(let error) = completion {
                    self?.error = error
                }
                self?.isLoading = false
            }, receiveValue: { [weak self] (response1, response2) in
                self?.mergeFriendLists(response1.response, response2.response)
                self?.isLoading = false
            })
            .store(in: &cancellables)
    }
    
    private func loadFriendsWithInvitationsState() {
        apiService.fetchFriendListWithInvitations()
            .sink(receiveCompletion: { [weak self] completion in
                if case .failure(let error) = completion {
                    self?.error = error
                }
                self?.isLoading = false
            }, receiveValue: { [weak self] response in
                self?.processFriendsWithInvitations(response.response)
                self?.isLoading = false
            })
            .store(in: &cancellables)
    }
    
    private func mergeFriendLists(_ list1: [Friend], _ list2: [Friend]) {
        var mergedDict: [String: Friend] = [:]
        
        // 合併兩個列表，如果有重複的 fid，保留 updateDate 較新的
        for friend in list1 + list2 {
            if let existingFriend = mergedDict[friend.fid] {
                if friend.updateDate > existingFriend.updateDate {
                    mergedDict[friend.fid] = friend
                }
            } else {
                mergedDict[friend.fid] = friend
            }
        }
        
        friends = Array(mergedDict.values)
        filteredFriends = friends
    }
    
    private func processFriendsWithInvitations(_ allFriends: [Friend]) {
        // 分離好友和邀請
        friends = allFriends.filter { $0.status == .completed }
        invitations = allFriends.filter { $0.status == .invitedSent || $0.status == .inviting }
        filteredFriends = friends
    }
    
    // MARK: - Helper Methods
    func getTopFriends() -> [Friend] {
        return friends.filter { $0.isTop }
    }
    
    func getNormalFriends() -> [Friend] {
        return friends.filter { $0.isTop }
    }
} 
