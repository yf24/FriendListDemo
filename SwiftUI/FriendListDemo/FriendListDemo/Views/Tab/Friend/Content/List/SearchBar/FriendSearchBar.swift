//
//  FriendSearchBar.swift
//  FriendListDemo
//
//  Created by TWIPC00587031E on 2026/1/19.
//

import SwiftUI

struct FriendSearchBar: View {
    
    // MARK: - Properties
    @Binding var searchText: String
    let onAction: (Action) -> Void
    
    // MARK: - Action
    enum Action {
        case addFriend
    }
    
    // MARK: - Body
    var body: some View {
        HStack(spacing: 15) {
            // 搜尋框
            searchField
            
            // 加好友按鈕
            addFriendButton
        }
        .padding(.horizontal, 30)
    }
}

// MARK: - Subviews
extension FriendSearchBar {
    
    private var searchField: some View {
        HStack(spacing: 8) {
            Image(.friendSearch)
            
            TextField("想轉一筆給誰呢？", text: $searchText)
                .font(.system(size: 14))
        }
        .padding(.horizontal, 10)
        .padding(.vertical, 11)
        .background(.steel.opacity(0.12))
        .cornerRadius(10)
    }
    
    private var addFriendButton: some View {
        Button(action: { onAction(.addFriend) }) {
            Image(.addFriendBtn)
                .resizable()
                .frame(width: 24, height: 24)
        }
    }
}

// MARK: - Preview
#Preview {
    VStack {
        FriendSearchBar(
            searchText: .constant(""),
            onAction: { print($0) }
        )
        
        FriendSearchBar(
            searchText: .constant("黃"),
            onAction: { print($0) }
        )
    }
}
