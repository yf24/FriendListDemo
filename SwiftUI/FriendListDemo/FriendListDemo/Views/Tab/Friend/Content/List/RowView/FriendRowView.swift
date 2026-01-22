//
//  FriendRowView.swift
//  FriendListDemo
//
//  Created by TWIPC00587031E on 2026/1/2.
//

import SwiftUI

struct FriendRowView: View {
    // MARK: - Properties
    // FIXME: 這個估計得用 binding
    let friend: Friend
    let onAction: (Action) -> Void
    
    // MARK: - Action
    enum Action {
        case transfer
        case invite
        case more
    }
    
    // MARK: - Body
    var body: some View {
        HStack(spacing: 15) {
            // 星星 + 頭像
            avatarSection
            
            // 名字 + 分隔線
            VStack(spacing: 0) {
                HStack {
                    Text(friend.name)
                        .font(.system(size: 16))
                        .foregroundColor(.lightGrey2)
                    
                    Spacer()
                    
                    // 按鈕組
                    buttonSection
                }
                .padding(.vertical, 10)
                
                // 分隔線：從名字位置延伸到最右側
                Divider()
                    .background(.transferMoney)
            }
        }
        .padding(.horizontal, 20)
    }
}

// MARK: - Subviews
extension FriendRowView {
    
    /// 星星 + 頭像
    private var avatarSection: some View {
        HStack(spacing: 0) {
            // 星星
            Image(.friendStar)
                .resizable()
                .frame(width: 14, height: 14)
                .padding(.leading, 10)
                .padding(.trailing, 6)
                .opacity(friend.isTop ? 1 : 0)
                
            // 頭像
            Image(.avatar)
                .resizable()
                .frame(width: 40, height: 40)
                .clipShape(Circle())
        }
    }
    
    /// 按鈕組（根據 status 顯示不同按鈕）
    @ViewBuilder
    private var buttonSection: some View {
        HStack(spacing: 10) {
            // 轉帳按鈕
            ActionButton(title: "轉帳", style: .primary) {
                onAction(.transfer)
            }
            
            // 根據 status 顯示「邀請中」或「•••」
            switch friend.status {
            case .invitedSent, .inviting:
                ActionButton(title: "邀請中", style: .secondary) {
                    onAction(.invite)
                }
            case .completed:
                Button(action: { onAction(.more) }) {
                    Image(.friendMore)
                        .frame(width: 18, height: 18)
                        .padding(.trailing, 10)
                }
            }
        }
    }
}

// MARK: - Action Button
struct ActionButton: View {
    
    enum Style {
        case primary    // 轉帳（粉紅邊框）
        case secondary  // 邀請中（灰邊框）
    }
    
    let title: String
    let style: Style
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.system(size: 14, weight: .medium))
                .foregroundColor(style == .primary ? .hotPink : .lightGrey)
                .padding(.horizontal, 12)
                .padding(.vertical, 6)
                .overlay(
                    RoundedRectangle(cornerRadius: 2)
                        .stroke(style == .primary ? .hotPink : .lightGrey, lineWidth: 1)
                )
        }
        .buttonStyle(.borderless)
    }
}

// MARK: - Preview
#Preview {
    VStack(spacing: 0) {
        // 邀請送出狀態
        FriendRowView(
            friend: Friend(
                name: "黃靖僑",
                status: .invitedSent,
                isTop: false,
                fid: "1",
                updateDate: Date()
            ),
            onAction: { print($0) }
        )
        
        // 置頂 + 邀請中
        FriendRowView(
            friend: Friend(
                name: "翁勳儀",
                status: .inviting,
                isTop: true,
                fid: "2",
                updateDate: Date()
            ),
            onAction: { print($0) }
        )
        
        // 已完成（顯示 •••）
        FriendRowView(
            friend: Friend(
                name: "洪佳好",
                status: .completed,
                isTop: false,
                fid: "3",
                updateDate: Date()
            ),
            onAction: { print($0) }
        )
    }
}
