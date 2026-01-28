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
    
    @State private var currentSwipedId: UUID? = nil
    
    var body: some View {
        NavigationStack {
            ScrollView {
                LazyVStack(spacing: 0) {
                    ForEach(items) { item in
                        SwipeableSettingRow(
                            item: item,
                            currentSwipedId: $currentSwipedId,
                            onDelete: {
                                deleteItem(item)
                            }
                        )
                    }
                }
            }
            .navigationTitle("設定")
        }
    }
    
    private func deleteItem(_ item: SettingItem) {
        withAnimation {
            items.removeAll { $0.id == item.id }
            currentSwipedId = nil
        }
    }
}

// MARK: - Swipeable Row
struct SwipeableSettingRow: View {
    let item: SettingItem
    @Binding var currentSwipedId: UUID?
    let onDelete: () -> Void
    
    @State private var offset: CGFloat = 0
    @State private var isDragging = false
    private let deleteWidth: CGFloat = 80
    
    // 計算屬性：判斷此 row 是否應該被展開
    private var isSwipedOpen: Bool {
        currentSwipedId == item.id
    }
    
    var body: some View {
        ZStack(alignment: .trailing) {
            // 刪除按鈕（背景）- 只在左滑時顯示
            if offset < 0 {
                HStack {
                    Spacer()
                    Button(action: {
                        withAnimation {
                            onDelete()
                        }
                    }) {
                        Image(systemName: "trash")
                            .foregroundColor(.white)
                            .frame(width: deleteWidth)
                            .frame(maxHeight: .infinity)
                    }
                    .background(Color.red)
                }
            }
            
            // 主內容 - 加上 NavigationLink
            NavigationLink {
                SettingDetailView(item: item)
            } label: {
                SettingRowView(item: item)
            }
            .buttonStyle(PlainButtonStyle())
            .disabled(offset != 0 || isDragging) // 當滑動展開或正在拖動時，禁用導航
            .offset(x: offset)
            .simultaneousGesture(
                DragGesture(minimumDistance: 10)
                    .onChanged { value in
                        if !isDragging {
                            isDragging = true
                            // 當開始拖動時，關閉其他已展開的 row
                            if currentSwipedId != nil && currentSwipedId != item.id {
                                currentSwipedId = nil
                            }
                        }
                        
                        let translation = value.translation.width
                        
                        // 如果目前是展開狀態，可以右滑關閉
                        if offset < 0 {
                            // 已經展開，允許右滑關閉
                            offset = max(min(translation - deleteWidth, 0), -deleteWidth)
                        } else {
                            // 未展開，只能左滑
                            if translation < 0 {
                                offset = max(translation, -deleteWidth)
                            }
                        }
                    }
                    .onEnded { value in
                        let translation = value.translation.width
                        
                        withAnimation(.spring()) {
                            // 如果目前在展開狀態
                            if offset < 0 {
                                // 右滑超過一半就關閉
                                if translation > deleteWidth / 2 {
                                    offset = 0
                                    currentSwipedId = nil
                                } else {
                                    // 否則保持展開
                                    offset = -deleteWidth
                                }
                            } else {
                                // 從關閉狀態左滑
                                if -offset > deleteWidth / 2 {
                                    offset = -deleteWidth
                                    currentSwipedId = item.id
                                } else {
                                    offset = 0
                                    if currentSwipedId == item.id {
                                        currentSwipedId = nil
                                    }
                                }
                            }
                        }
                        
                        // 延遲重置 isDragging，確保 NavigationLink 不會被意外觸發
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                            isDragging = false
                        }
                    }
            )
        }
        .clipped()
        .contentShape(Rectangle())
        .simultaneousGesture(
            TapGesture()
                .onEnded { _ in
                    // 如果這個 row 已展開，點擊關閉它
                    if offset != 0 {
                        withAnimation(.spring()) {
                            offset = 0
                            currentSwipedId = nil
                        }
                    }
                    // 如果有其他項目展開，點擊任何地方都關閉它
                    else if currentSwipedId != nil {
                        withAnimation(.spring()) {
                            currentSwipedId = nil
                        }
                    }
                }
        )
        .onChange(of: currentSwipedId) { oldValue, newValue in
            // 當其他 row 被滑動時，關閉這個 row
            if newValue != item.id && offset != 0 {
                withAnimation(.spring()) {
                    offset = 0
                }
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

// MARK: - Detail View
struct SettingDetailView: View {
    let item: SettingItem
    
    var body: some View {
        VStack(spacing: 20) {
            Image(systemName: item.icon)
                .font(.system(size: 60))
                .foregroundColor(.hotPink)
            
            Text(item.title)
                .font(.title)
            
            if let subtitle = item.subtitle {
                Text(subtitle)
                    .foregroundColor(.gray)
            }
            
            Spacer()
        }
        .padding(.top, 40)
        .navigationTitle(item.title)
        .navigationBarTitleDisplayMode(.inline)
    }
}

// MARK: - Preview
#Preview {
    SettingsView()
}
