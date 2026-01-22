//
//  FriendEmptyView.swift
//  FriendListDemo
//
//  Created by TWIPC00587031E on 2026/1/21.
//

import SwiftUI

struct FriendEmptyView: View {
    
    // MARK: - Properties
    let onAction: (Action) -> Void
    
    // MARK: - Action
    enum Action {
        case addFriend
        case setKokoId
    }
    
    // MARK: - Body
    var body: some View {
        VStack(spacing: 16) {
            Spacer()
            
            Image(.noFriend)
            
            Text("就從加好友開始吧：）")
                .font(.system(size: 21, weight: .medium))
                .foregroundColor(.lightGrey2)
            
            Text("與好友們一起用 KOKO 聊起來！\n還能互相收付款、發紅包喔：）")
                .font(.system(size: 14))
                .foregroundColor(.lightGrey)
                .multilineTextAlignment(.center)
            
            // 加好友按鈕
            addFriendButton
                .padding(.top, 24)
            
            // 設定 KOKO ID 連結
            setKokoIdLink
                .padding(.top, 16)
            
            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

// MARK: - Subviews
extension FriendEmptyView {
    
    private var addFriendButton: some View {
        Button(action: { onAction(.addFriend) }) {
            ZStack {
                // 文字置中
                Text("加好友")
                    .font(.system(size: 16, weight: .medium))
                
                // 笑臉靠右
                HStack {
                    Spacer()
                    
                    Image(.smileFace)
                        .resizable()
                        .frame(width: 24, height: 24)
                        .padding(.trailing, 8)
                }
            }
            .foregroundColor(.white)
            .frame(width: 192, height: 40)
            .background(
                LinearGradient(
                    colors: [.frogGreen, .b],
                    startPoint: .leading,
                    endPoint: .trailing
                )
            )
            .cornerRadius(20)
        }
    }
    
    private var setKokoIdLink: some View {
        HStack(spacing: 0) {
            Text("幫助好友更快找到你？")
                .font(.system(size: 14))
                .foregroundColor(.lightGrey)
            
            Button(action: { onAction(.setKokoId) }) {
                Text("設定 KOKO ID")
                    .font(.system(size: 14))
                    .foregroundColor(.hotPink)
                    .underline()
            }
        }
    }
}

// MARK: - Preview
#Preview {
    FriendEmptyView(
        onAction: { print($0) }
    )
}
