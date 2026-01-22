//
//  FriendViewModel.swift
//  FriendListDemo
//
//  Created by TWIPC00587031E on 2025/12/3.
//

import Foundation
import Combine

class FriendViewModel: ObservableObject {
    
    // MARK: - Published Properties
    @Published var userName: String = ""
    @Published var kokoId: String? = nil
    @Published var friends: [Friend] = []
    
    // MARK: - Private
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - Init
    init() {
        loadMockData()
    }
    
    // MARK: - Action Handlers
    func handleHeaderAction(_ action: FriendHeaderView.Action) {
        switch action {
        case .atmTap:
            print("ATM tapped")
        case .transferTap:
            print("Transfer tapped")
        case .scanTap:
            print("Scan tapped")
        case .avatarTap:
            print("Avatar tapped")
        case .kokoIdTap:
            print("KOKO ID tapped")
        case .friendTap:
            print("Friend tab tapped")
        case .chatTap:
            print("Chat tab tapped")
        }
    }
    
    func handleContentAction(_ action: FriendContentView.Action) {
        switch action {
        case .addFriend:
            print("Add friend tapped")
        case .setKokoId:
            print("Set KOKO ID tapped")
        case .transfer(let friend):
            print("Transfer to \(friend.name)")
        case .invite(let friend):
            print("Invite \(friend.name)")
        case .more(let friend):
            print("More for \(friend.name)")
        case .refresh:
            print("Refresh")
            refreshData()
        }
    }
    
    // MARK: - Private Methods
    private func loadMockData() {
        userName = "蔡國泰"
        kokoId = "Mike"
        
        friends = [
            Friend(name: "黃靖僑", status: .invitedSent, isTop: false, fid: "1", updateDate: Date()),
            Friend(name: "翁勳儀", status: .inviting, isTop: true, fid: "2", updateDate: Date()),
            Friend(name: "洪佳好", status: .completed, isTop: false, fid: "3", updateDate: Date())
        ]
    }
    
    private func refreshData() {
        // TODO: 呼叫 API 重新載入
    }
}
