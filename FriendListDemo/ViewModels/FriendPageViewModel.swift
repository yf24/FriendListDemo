import Foundation
import Combine

enum FriendListState {
    case testData
    case empty
    case friendsOnly
    case friendsWithInvitations
}

class FriendPageViewModel {
    private var cancellables = Set<AnyCancellable>()
    private let apiService = APIService.shared

    // MARK: - Published Properties
    @Published var user: User?
    @Published var allFriends: [Friend] = []
    @Published var friends: [Friend] = [] 
    @Published var invitations: [Friend] = []
    @Published var filteredFriends: [Friend] = []
    @Published var isLoading: Bool = false
    @Published var error: APIError?
    @Published var currentState: FriendListState = .empty
    @Published var searchText: String = ""
    
    // MARK: - Init
    init() {
        setupSearchBinding()
    }
    
    // MARK: - Public Methods
    func loadData(for state: FriendListState) {
        isLoading = true
        currentState = state
        
        // 只有非 empty 狀態才載入使用者資料
        if state != .empty {
            loadUserData()
        }
        
        // 根據狀態載入不同的好友列表
        switch state {
        case .testData:
            loadTestDataSate()
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

    // MARK: - Data Request
    private func loadUserData() {
        apiService.fetchUserData()
            .sink(receiveCompletion: { [weak self] completion in
                if case .failure(let error) = completion {
                    self?.error = error
                }
            }, receiveValue: { [weak self] user in
                self?.user = user
            })
            .store(in: &cancellables)
    }

    private func loadTestDataSate() {
        let mockFriends = [
            Friend(name: "測試好友",
                   status: .invitedSent,
                   isTop: true,
                   fid: "001",
                   updateDateString: "20240701"),
            Friend(name: "測試好友2",
                   status: .completed,
                   isTop: false,
                   fid: "002",
                   updateDateString: "20240702"),
            Friend(name: "測試邀請好友1",
                   status: .inviting,
                   isTop: false,
                   fid: "003",
                   updateDateString: "20240703"),
            Friend(name: "測試邀請好友2",
                   status: .inviting,
                   isTop: false,
                   fid: "004",
                   updateDateString: "20240704"),
            Friend(name: "測試邀請好友3",
                   status: .inviting,
                   isTop: false,
                   fid: "005",
                   updateDateString: "20240705"),
        ]
        updateAllFriendsAndSplit(mockFriends)
    }
    
    private func loadEmptyState() {
        apiService.fetchEmptyFriendList()
            .sink(receiveCompletion: { [weak self] completion in
                if case .failure(let error) = completion {
                    self?.error = error
                }
                self?.isLoading = false
            }, receiveValue: { [weak self] response in
                self?.updateAllFriendsAndSplit(response.response)
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
                let merged = self?.mergeFriendLists(response1.response, response2.response) ?? []
                self?.updateAllFriendsAndSplit(merged)
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
                self?.updateAllFriendsAndSplit(response.response)
                self?.isLoading = false
            })
            .store(in: &cancellables)
    }
    
    private func updateAllFriendsAndSplit(_ all: [Friend]) {
        allFriends = all
        friends = all.filter { $0.status == .completed || $0.status == .invitedSent }
        invitations = all.filter { $0.status == .inviting }
        filteredFriends = friends
    }
    
    private func mergeFriendLists(_ list1: [Friend], _ list2: [Friend]) -> [Friend] {
        var mergedDict: [String: Friend] = [:]
        for friend in list1 + list2 {
            if let existingFriend = mergedDict[friend.fid] {
                if friend.updateDate > existingFriend.updateDate {
                    mergedDict[friend.fid] = friend
                }
            } else {
                mergedDict[friend.fid] = friend
            }
        }
        return Array(mergedDict.values)
    }
} 
