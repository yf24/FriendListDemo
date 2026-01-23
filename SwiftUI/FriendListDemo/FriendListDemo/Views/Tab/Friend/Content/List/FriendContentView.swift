//
//  FriendContentView.swift
//  FriendListDemo
//
//  Created by TWIPC00587031E on 2026/1/2.
//

import SwiftUI

extension FriendContentView {
    // MARK: - Action
    enum Action {
        case addFriend
        case setKokoId
        case transfer(Friend)
        case invite(Friend)
        case more(Friend)
        case refresh
        case delete(Friend)
        case toggleTop(Friend)
        case reorder(from: IndexSet, to: Int)
    }
}

struct FriendContentView: View {
    // MARK: - Properties
    @State private var searchText: String = ""
    @State private var isEditMode: EditMode = .inactive
    @Binding var friends: [Friend]
    let onAction: (Action) -> Void
    
    private var filteredFriends: [Friend] {
        if searchText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            return friends
        } else {
            return friends.filter { $0.name.contains(searchText) }
        }
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
            ForEach(isEditMode == .active ? friends : filteredFriends) { friend in
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
                .listRowBackground(Color.clear)  // 移除背景點擊效果
                .swipeActions(edge: .trailing, allowsFullSwipe: true) {
                    // 刪除按鈕（最右邊）
                    Button(role: .destructive) {
                        onAction(.delete(friend))
                    } label: {
                        Label("刪除", systemImage: "trash")
                    }
                    
                    // 置頂按鈕
                    Button {
                        onAction(.toggleTop(friend))
                    } label: {
                        Label(
                            friend.isTop ? "取消最愛" : "最愛",
                            systemImage: friend.isTop ? "star.slash" : "star"
                        )
                    }
                    .tint(.yellow)
                }
                .swipeActions(edge: .leading, allowsFullSwipe: false) {
                    // 右滑出的按鈕
                    Button {
                        onAction(.transfer(friend))
                    } label: {
                        Label("轉帳", systemImage: "dollarsign.circle")
                    }
                    .tint(.green)
                }
            }
            .onMove { from, to in
                onAction(.reorder(from: from, to: to))
            }
            .onDelete { indexSet in
                indexSet.forEach { index in
                    onAction(.delete(friends[index]))
                }
            }
        }
        .listStyle(.plain)
        .environment(\.editMode, $isEditMode)
        .refreshable {
            onAction(.refresh)
        }
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button(isEditMode == .active ? "完成" : "編輯") {
                    withAnimation {
                        isEditMode = isEditMode == .active ? .inactive : .active
                    }
                }
            }
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
    struct PreviewWrapper: View {
        @StateObject var vm = FriendViewModel()
        
        var body: some View {
            NavigationStack {
                FriendContentView(
                    friends: $vm.friends,
                    onAction: { vm.handleContentAction($0) }
                )
            }
        }
    }
    
    return PreviewWrapper()
}

//#Preview("Empty State") {
//    FriendContentView(
//        friends: .constant([]),
//        onAction: { print($0) }
//    )
//}
