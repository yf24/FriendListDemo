//
//  MoneySubViews.swift
//  FriendListDemo
//
//  Created by TWIPC00587031E on 2026/1/27.
//

import SwiftUI

// MARK: - 帳戶詳情
struct AccountRow: View {
    let name: String
    let balance: String
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text(name)
                    .font(.system(size: 16))
                    .foregroundColor(.primary)
                Text(balance)
                    .font(.system(size: 14))
                    .foregroundColor(.gray)
            }
            Spacer()
        }
        .padding(.vertical, 4)
    }
}

struct AccountDetailView: View {
    let account: Account
    
    var body: some View {
        VStack(spacing: 24) {
            // 帳戶卡片
            VStack(alignment: .leading, spacing: 12) {
                Text(account.name)
                    .font(.headline)
                    .foregroundColor(.secondary)
                
                Text(account.balance)
                    .font(.system(size: 36, weight: .bold))
                    .foregroundColor(.primary)
                
                HStack {
                    Text("帳戶 ID")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    Text(account.id)
                        .font(.caption)
                        .foregroundColor(.gray)
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding()
            .background(Color(.systemGray6))
            .cornerRadius(12)
            .padding(.horizontal)
            
            // 操作按鈕
            VStack(spacing: 12) {
                Button {
                    // 轉帳操作
                } label: {
                    Label("轉帳", systemImage: "arrow.left.arrow.right")
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(.borderedProminent)
                
                Button {
                    // 繳費操作
                } label: {
                    Label("繳費", systemImage: "doc.text")
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(.bordered)
            }
            .padding(.horizontal)
            
            Spacer()
        }
        .padding(.top)
        .navigationTitle(account.name)
        .navigationBarTitleDisplayMode(.inline)
    }
}

// MARK: - 轉帳
struct TransferView: View {
    @Binding var path: NavigationPath
    
    var body: some View {
        VStack(spacing: 20) {
            Text("轉帳頁面")
                .font(.title)
            
            Button("下一步：確認轉帳") {
                path.append(MoneyRoute.transferConfirm)
            }
            .buttonStyle(.borderedProminent)
            
            Button("返回首頁（Pop to Root）") {
                path = NavigationPath()
            }
            .foregroundColor(.red)
        }
        .navigationTitle("轉帳")
    }
}

// MARK: - 繳費
struct PaymentView: View {
    var body: some View {
        Text("繳費頁面")
            .navigationTitle("繳費")
    }
}

// MARK: - 交易紀錄
struct TransactionHistoryView: View {
    var body: some View {
        List {
            ForEach(1..<11) { index in
                HStack {
                    Text("交易 \(index)")
                    Spacer()
                    Text("-NT$ \(index * 100)")
                        .foregroundColor(.red)
                }
            }
        }
        .navigationTitle("交易紀錄")
    }
}

// MARK: - 目標頁面
struct AboutView: View {
    var body: some View {
        Text("關於我們頁面")
            .navigationTitle("關於我們")
    }
}

struct SettingsDetailView: View {
    var body: some View {
        Text("設定詳情頁面")
            .navigationTitle("設定")
    }
}

struct TransferConfirmView: View {
    @Binding var path: NavigationPath
    
    var body: some View {
        VStack(spacing: 20) {
            Text("確認轉帳資訊")
                .font(.title)
            
            Button("完成，返回首頁") {
                path = NavigationPath()
            }
            .buttonStyle(.borderedProminent)
            
            Button("返回上一頁（Pop）") {
                path.removeLast()
            }
            .foregroundColor(.orange)
        }
        .navigationTitle("確認")
    }
}
