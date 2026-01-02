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
        VStack(spacing: 0) {
            HStack(spacing: 15) {
                // 星星 + 頭像
                avatarSection
                    .border(.red)
                
                // 名字
                Text(friend.name)
                    .font(.system(size: 16))
                    .foregroundColor(.lightGrey2)
                    .border(.red)
                
                Spacer()
                
                // 按鈕組
                buttonSection
                    .border(.red)
            }
            
            .padding(.vertical, 10)
            .border(.frogGreen)
            
            // 分隔線
            Divider()
                .padding(.leading, 85)  // 對齊名字位置
        }
        .padding(.horizontal, 20)
//        .border(.red)
    }
}

// MARK: - Subviews
extension FriendRowView {
    
    /// 星星 + 頭像
    private var avatarSection: some View {
        HStack(spacing: 0) {
            // 星星
            if friend.isTop {
                Image(.friendStar)  // 換成你的 asset 名稱
                    .resizable()
                    .frame(width: 14, height: 14)
                    .padding(.leading, 10)
                    .padding(.trailing, 6)
//                    .visibale
            } else {
                Rectangle()
                    .frame(width: 14, height: 14)
                    .opacity(0)
                    .padding(.leading, 10)
                    .padding(.trailing, 6)
            }
                
            
            // 頭像
            Image(.avatar)  // 換成你的 asset 名稱
                .resizable()
                .frame(width: 40, height: 40)
                .clipShape(Circle())
        }
    }
    
    /// 按鈕組（根據 status 顯示不同按鈕）
    @ViewBuilder
    private var buttonSection: some View {
        HStack(spacing: 10) {
            // 轉帳按鈕（都會顯示）
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
                    Image("more")  // 換成你的 asset 名稱，就是 ••• 的圖
                        .frame(width: 18, height: 18)
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
                .font(.system(size: 14))
                .foregroundColor(style == .primary ? .hotPink : .lightGrey2)
                .padding(.horizontal, 12)
                .padding(.vertical, 6)
                .overlay(
                    RoundedRectangle(cornerRadius: 4)
                        .stroke(style == .primary ? Color.hotPink : Color.lightGrey2, lineWidth: 1)
                )
        }
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
