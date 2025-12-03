//
//  FriendHeaderView.swift
//  FriendListDemo
//
//  Created by TWIPC00587031E on 2025/12/1.
//

import SwiftUI

enum FriendHeaderAction {
    case atmTap, transferTap, scanTap, avatarTap, kokoIdTap, friendTap, chatTap
}

struct FriendHeaderView: View {
    // MARK: - Properties
    var userName: String = "紫晽"
    var kokoId: String? = nil  // nil 時顯示「設定 KOKO ID」
    
    var onAction: (FriendHeaderAction) -> Void
    
    var body: some View {
        VStack(spacing: 0) {
            // 頂部按鈕列
            topButtonBar
            
            // 主要內容 Stack
            VStack(alignment: .leading, spacing: 6) {
                userInfoView
                // FIXME: 邀請展開 view 還沒做
//                inviteExpandView
                controlPanelView
            }
            
            // 底部分隔線
            Divider()
                .background(Color("veryLightPink1"))
        }
        .background(Color(.systemBackground))
    }
}

// MARK: - Subviews
extension FriendHeaderView {
    /// 頂部按鈕列（ATM、Transfer、Scan）
    private var topButtonBar: some View {
        HStack {
            Button(action: { onAction(.atmTap) }) {
                Image(.atmBtn)
                    .frame(width: 24, height: 24)
            }
            
            Button(action: { onAction(.transferTap) }) {
                Image(.transferBtn)
                    .frame(width: 24, height: 24)
            }
            .padding(.leading, 24)
            
            Spacer()
            
            Button(action: { onAction(.scanTap) }) {
                Image(.scanBtn)
                    .frame(width: 24, height: 24)
            }
        }
        .padding(.horizontal, 20)
    }
    
    /// 使用者資訊區塊
    private var userInfoView: some View {
        HStack {
            VStack(alignment: .leading, spacing: 8) {
                Text(userName)
                    .font(.system(size: 17, weight: .medium))
                    .foregroundColor(Color.lightGrey2)
                
                Button(action: { onAction(.kokoIdTap) }) {
                    kokoIdLabel
                }

                Spacer()
            }
            .padding(.leading, 30)
            .padding(.top, 35)

            Spacer()
            
            Button(action: { onAction(.avatarTap) }) {
                Image("avatar")
                    .frame(width: 52, height: 54)
            }
            .padding(.trailing, 30)
        }
        .frame(height: 102)
    }
    
    /// koko ID
    @ViewBuilder
    private var kokoIdLabel: some View {
        if let kokoId = kokoId {
            HStack(spacing: 0) {
                Text("KOKO ID：\(kokoId)")
                Image(.kokoIdArrow)
                    .font(.system(size: 10))
            }
            .font(.system(size: 13))
            .foregroundColor(.lightGrey2)
        } else {
            Text("設定 KOKO ID")
                .font(.system(size: 13))
                .foregroundColor(.lightGrey2)
        }
    }
    
    /// 邀請卡片展開區
    // FIXME:（之後替換成實際的 FriendInviteCardExpandView）
    private var inviteExpandView: some View {
        Color.frogGreen
            .frame(height: 94)
    }
    
    /// 好友/聊天 切換按鈕
    private var controlPanelView: some View {
        // FIXME: 小tab選到的底線還沒做
        HStack(spacing: 0) {
            Button(action: { onAction(.friendTap) }) {
                Text("好友")
                    .font(.system(size: 13, weight: .medium))
                    .foregroundColor(Color.lightGrey2)
                    .frame(width: 50, height: 34)
            }
            
            Button(action: { onAction(.chatTap) }) {
                Text("聊天")
                    .font(.system(size: 13))
                    .foregroundColor(Color.lightGrey2)
                    .frame(width: 50, height: 34)
            }
        }
        .padding(.leading, 20)
//        .frame(height: 34)
    }
}

// MARK: - Preview
#Preview {
    VStack(spacing: 20) {
        FriendHeaderView(
            kokoId: "Mike",
            onAction: {
                switch $0 {
                case .atmTap:
                    print("atmTap")
                case .avatarTap:
                    print("avatarTap")
                case .chatTap:
                    print("chatTap")
                case .friendTap:
                    print("friendTap")
                case .kokoIdTap:
                    print("kokoIdTap")
                case .scanTap:
                    print("scanTap")
                case .transferTap:
                    print("transferTap")
                }
            }
        )
        
        Spacer()
//        Color.red
//        FriendHeaderView()
    }
}
