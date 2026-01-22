//
//  FriendView.swift
//  FriendListDemo
//
//  Created by TWIPC00587031E on 2025/12/3.
//

import SwiftUI
import Combine

struct FriendView: View {
    @StateObject var vm = FriendViewModel()
    
    var body: some View {
        VStack(spacing: 0) {
            FriendHeaderView(
                userName: vm.userName,
                kokoId: vm.kokoId,
                onAction: { vm.handleHeaderAction($0) }
            )
            .padding(.bottom, 15)
            
            FriendContentView(
                friends: vm.friends,
                onAction: { vm.handleContentAction($0) }
            )
        }
    }
}

#Preview {
    FriendView()
}
