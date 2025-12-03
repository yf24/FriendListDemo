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
        FriendHeaderView(
            onAction: { vm.actionSubject.send($0) }
        )
        
        // FIXME: content 還沒做
//        FriendContentView()
        Spacer()
    }
}

#Preview {
    FriendView()
}
