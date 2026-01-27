//
//  MoneyView.swift
//  FriendListDemo
//
//  Created by TWIPC00587031E on 2026/1/27.
//

import SwiftUI

// MARK: - Model
struct Account: Identifiable, Hashable {
    let id: String
    let name: String
    let balance: String
}

// MARK: - Route
enum MoneyRoute: Hashable {
    case transfer
    case transferConfirm
    case payment
    case history
}

// MARK: - MoneyView
struct MoneyView: View {
    @State private var path = NavigationPath()
    @State private var selectedAccount: Account?
    
    let accounts = [
        Account(id: "1", name: "台幣帳戶", balance: "NT$ 50,000"),
        Account(id: "2", name: "外幣帳戶", balance: "US$ 1,200")
    ]
    
    var body: some View {
        NavigationStack(path: $path) {
            List {
                // MARK: 寫法 1 & 2：基本 NavigationLink
                Section("寫法 1 & 2：NavigationLink") {
                    // 寫法 1：基本款
                    NavigationLink("關於我們") {
                        AboutView()
                    }
                    
                    // 寫法 2：自訂 label
                    NavigationLink {
                        SettingsDetailView()
                    } label: {
                        HStack {
                            Image(systemName: "gear")
                            Text("設定（自訂樣式）")
                        }
                    }
                }
                
                // MARK: 寫法 3：帶資料過去
                Section("寫法 3：帶資料") {
                    ForEach(accounts) { account in
                        NavigationLink {
                            AccountDetailView(account: account)  // 傳整個物件
                        } label: {
                            AccountRow(name: account.name, balance: account.balance)
                        }
                    }
                }
                
                // MARK: 寫法 4：navigationDestination(item:)
                Section("寫法 4：navigationDestination(item:)") {
                    ForEach(accounts) { account in
                        Button {
                            selectedAccount = account  // 設定後自動導航
                        } label: {
                            HStack {
                                Text(account.name)
                                Spacer()
                                Text("點我（自定義文字）")
                                    .font(.caption)
                                    .foregroundColor(.gray)
                            }
                        }
                    }
                }
                
                // MARK: 寫法 5：NavigationPath: Route 觸發
                Section("寫法 5：NavigationPath: Route 觸發") {
                    Button("轉帳") {
                        path.append(MoneyRoute.transfer)
                    }
                    
                    Button("繳費") {
                        path.append(MoneyRoute.payment)
                    }
                    
                    Button("交易紀錄") {
                        path.append(MoneyRoute.history)
                    }
                    
                    Button("一次跳兩層（轉帳 → 確認）") {
                        path.append(MoneyRoute.transfer)
                        path.append(MoneyRoute.transferConfirm)
                    }
                    .foregroundColor(.orange)
                }
            }
            .navigationTitle("錢錢")
            // 寫法 4：item 觸發
            .navigationDestination(item: $selectedAccount) { account in
                AccountDetailView(account: account)
            }
            // 寫法 5：Route 觸發
            .navigationDestination(for: MoneyRoute.self) { route in
                switch route {
                case .transfer:
                    TransferView(path: $path)
                case .transferConfirm:
                    TransferConfirmView(path: $path)
                case .payment:
                    PaymentView()
                case .history:
                    TransactionHistoryView()
                }
            }
        }
    }
}

// MARK: - Preview
#Preview {
    MoneyView()
}
