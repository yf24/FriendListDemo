//
//  ContentView.swift
//  FriendListDemo
//
//  Created by TWIPC00587031E on 2025/11/14.
//

import SwiftUI

struct MainTabView: View {
    @State private var selectedTab = 1
    
    var body: some View {
        TabView(selection: $selectedTab) {
            moneyTab
            friendTab
            koTab
            bookkeepingTab
            settingsTab
        }
        .tint(Color(.hotPink))
    }
}

// MARK: - Tabs
extension MainTabView {
    private var moneyTab: some View {
        MoneyView()  // 已經有 NavigationStack 了，不用再包
            .tabItem {
                Image(.tabMoney)
                Text("錢錢")
            }
            .tag(1)
    }
    
    private var friendTab: some View {
        NavigationStack {
            FriendView()
        }
        .tabItem {
            Image(.tabFriend)
            Text("朋友")
        }
        .tag(2)
    }
    
    private var koTab: some View {
        NavigationStack {
            Text("KO 頁面")
        }
        .tabItem {
            Image(.tabKO)
            Text("KO")
        }
        .tag(3)
    }
    
    private var bookkeepingTab: some View {
        NavigationStack {
            Text("記帳頁面")
        }
        .tabItem {
            Image(.tabBookkeeping)
            Text("記帳")
        }
        .tag(4)
    }
    
    private var settingsTab: some View {
        NavigationStack {
            Text("設定頁面")
        }
        .tabItem {
            Image(.tabSettings)
            Text("設定")
        }
        .tag(5)
    }
}

#Preview {
    MainTabView()
}
