//
//  FriendContentView.swift
//  FriendListDemo
//
//  Created by TWIPC00587031E on 2026/1/2.
//

import SwiftUI

struct FriendContentView: View {
    // MARK: - Properties
    @State private var searchText: String = ""
    let friends: [Friend]
    let onAction: (Action) -> Void
    
    private var filteredFriends: [Friend] {
        if searchText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            return friends
        } else {
            return friends.filter { $0.name.contains(searchText) }
        }
    }
    
    // MARK: - Action
    enum Action {
        case addFriend
        case setKokoId
        case transfer(Friend)
        case invite(Friend)
        case more(Friend)
        case refresh
    }
    
    // MARK: - Body
    var body: some View {
        VStack(spacing: 0) {
            // 無好友 (空狀態畫面)
            if friends.isEmpty {
                FriendEmptyView(
                    onAction: { action in
                        switch action {
                        case .addFriend:
                            onAction(.addFriend)
                        case .setKokoId:
                            onAction(.setKokoId)
                        }
                    }
                )
            } else {
                // 搜尋框
                FriendSearchBar(
                    searchText: $searchText,
                    onAction: { action in
                        switch action {
                        case .addFriend:
                            onAction(.addFriend)
                        }
                    }
                )
                .padding(.bottom, 10)
                
                // 列表或無結果
                if filteredFriends.isEmpty {
                    noSearchResultView
                } else {
                    friendList
                }
            }
        }
    }
}

// MARK: - Subviews
extension FriendContentView {
    
    private var friendList: some View {
        List {
            ForEach(filteredFriends) { friend in
                FriendRowView(friend: friend) { action in
                    switch action {
                    case .transfer:
                        onAction(.transfer(friend))
                    case .invite:
                        onAction(.invite(friend))
                    case .more:
                        onAction(.more(friend))
                    }
                }
                .listRowInsets(EdgeInsets())  // 移除預設 padding
                .listRowSeparator(.hidden)    // 隱藏預設分隔線（我們自己畫）
            }
        }
        .listStyle(.plain)
        .refreshable {
            onAction(.refresh)
        }
    }
    
    private var noSearchResultView: some View {
        VStack {
            Spacer()
            
            Text("查無「\(searchText)」相關結果")
                .font(.system(size: 14))
                .foregroundColor(.lightGrey)
            
            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

// MARK: - Preview
#Preview {
    FriendContentView(
        friends: [
            Friend(name: "黃靖僑", status: .invitedSent, isTop: false, fid: "1", updateDate: Date()),
            Friend(name: "翁勳儀", status: .inviting, isTop: true, fid: "2", updateDate: Date()),
            Friend(name: "洪佳好", status: .completed, isTop: false, fid: "3", updateDate: Date())
        ],
        onAction: { print($0) }
    )
}

#Preview("Empty State") {
    FriendContentView(
        friends: [],
        onAction: { print($0) }
    )
}
