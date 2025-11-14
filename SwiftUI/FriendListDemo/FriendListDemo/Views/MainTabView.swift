//
//  ContentView.swift
//  FriendListDemo
//
//  Created by TWIPC00587031E on 2025/11/14.
//

import SwiftUI

struct MainTabView: View {
    @State private var selectedTab = 0
    
    var body: some View {
        TabView(selection: $selectedTab) {
            NavigationStack {
//                FriendsView()
                View()
            }
            .tabItem {
                Image(systemName: "person.2.fill")
                Text("朋友")
            }
            .tag(0)
            
            NavigationStack {
//                ChatListView()
                View()
            }
            .tabItem {
                Image(systemName: "message.fill")
                Text("聊天")
            }
            .tag(1)
            
            // ... 其他 tabs
        }
        .tint(.pink) // Tab 選中顏色
    }
}

#Preview {
    MainTabView()
}
