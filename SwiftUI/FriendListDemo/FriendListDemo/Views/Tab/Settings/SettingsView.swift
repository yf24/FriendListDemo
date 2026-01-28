//
//  SettingsView.swift
//  FriendListDemo
//
//  Created by TWIPC00587031E on 2026/1/28.
//

import SwiftUI

// MARK: - Model
struct SettingItem: Identifiable {
    let id = UUID()
    let icon: String
    let title: String
    let subtitle: String?
    
    init(icon: String, title: String, subtitle: String? = nil) {
        self.icon = icon
        self.title = title
        self.subtitle = subtitle
    }
}

// MARK: - SettingsView
struct SettingsView: View {
    
    @State private var items: [SettingItem] = [
        SettingItem(icon: "person.circle", title: "個人資料", subtitle: "編輯你的個人資訊"),
        SettingItem(icon: "bell", title: "通知設定", subtitle: "管理推播通知"),
        SettingItem(icon: "lock", title: "隱私與安全", subtitle: nil),
        SettingItem(icon: "creditcard", title: "付款方式", subtitle: "管理信用卡與帳戶"),
        SettingItem(icon: "questionmark.circle", title: "幫助中心", subtitle: nil),
        SettingItem(icon: "info.circle", title: "關於我們", subtitle: "版本 1.0.0"),
    ]
    
    var body: some View {
        NavigationStack {
            ScrollView {
                LazyVStack(spacing: 0) {
                    ForEach(items) { item in
                        SettingRowView(item: item)
                    }
                }
            }
            .navigationTitle("設定")
            .refreshable {
                // Pull to refresh 也能用
                print("Refreshing...")
            }
        }
    }
}

// MARK: - SettingRowView
struct SettingRowView: View {
    let item: SettingItem
    
    var body: some View {
        VStack(spacing: 0) {
            HStack(spacing: 16) {
                // Icon
                Image(systemName: item.icon)
                    .font(.system(size: 22))
                    .foregroundColor(.hotPink)
                    .frame(width: 32)
                
                // Title & Subtitle
                VStack(alignment: .leading, spacing: 4) {
                    Text(item.title)
                        .font(.system(size: 16))
                        .foregroundColor(.primary)
                    
                    if let subtitle = item.subtitle {
                        Text(subtitle)
                            .font(.system(size: 13))
                            .foregroundColor(.gray)
                    }
                }
                
                Spacer()
                
                // Arrow
                Image(systemName: "chevron.right")
                    .font(.system(size: 14))
                    .foregroundColor(.gray)
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 16)
            
            // Divider
            Divider()
                .padding(.leading, 68)
        }
        .background(Color.white)
    }
}

// MARK: - Preview
#Preview {
    SettingsView()
}
