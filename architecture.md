# 好友頁面架構設計

## 📋 需求概述

這是一個好友頁面，包含：
- 好友列表 + 聊天列表
- Header 包含用戶資訊和控制面板
- Header 資料不會因為 tab 切換而改變
- Header 按鈕（除了 Friend/Chat）不會影響 tab 切換

## 🏗️ UI 架構層級

```
FriendPageViewController (容器)
└── ContainerView (內容管理)
    ├── HeaderView (靜態容器)
    │   ├── User Info (獨立)
    │   │   ├── Avatar Button
    │   │   ├── Name Label
    │   │   └── KOKO ID Button
    │   ├── Control Panel (獨立)
    │   │   ├── ATM Button
    │   │   ├── Transfer Button
    │   │   └── Scan Button
    │   └── Tab Buttons (影響內容區域)
    │       ├── Friend Button
    │       └── Chat Button
    └── Content Views (動態內容)
        ├── FriendView (好友列表)
        │   ├── UITableView (header: FriendListHeaderView, cell: FriendListCell) (好友列表)
        │   ├── EmptyStateView (空狀態)
        └── ChatView (聊天列表)
            └── ChatListView (聊天列表)
```

## 🔄 事件流程

### Tab 切換流程
```
HeaderView.FriendButton → ViewController → ContainerView.show(tab: .friend)
HeaderView.ChatButton → ViewController → ContainerView.show(tab: .chat)
```

### 其他按鈕流程
```
HeaderView.ATMButton → ViewController → AlertUtils.showAlert()
HeaderView.TransferButton → ViewController → AlertUtils.showAlert()
HeaderView.ScanButton → ViewController → AlertUtils.showAlert()
HeaderView.AvatarButton → ViewController → AlertUtils.showAlert()
HeaderView.KokoIdButton → ViewController → AlertUtils.showAlert()
```

### 內容區域事件
```
FriendView.onAddFriendTapped → ContainerView → ViewController
FriendView.onSetKokoIdLabelTapped → ContainerView → ViewController
FriendView.onTransferTapped → ContainerView → ViewController
FriendView.onInviteTapped → ContainerView → ViewController
FriendView.onMoreTapped → ContainerView → ViewController
```

## 🎯 設計原則

### 1. 責任分離
- **ViewController**: 事件轉發和協調、資料流管理
- **ContainerView**: 內容區域管理
- **HeaderView**: 靜態 UI 容器
- **FriendView/ChatView**: 具體內容實作（如 FriendView 內含 tableView）

### 2. 事件驅動
- 使用 closure 回調進行事件傳遞
- 避免直接操作其他 View
- 透過 ViewController 進行事件轉發

### 3. 狀態管理
- Header 狀態獨立，不受 tab 切換影響
- 內容區域狀態由 ContainerView 管理
- 使用 `isHidden` 控制內容顯示

## 💻 程式碼範例

### ViewController 事件綁定
```swift
// Tab 切換
containerView.headerView.onFriendButtonTapped = { [weak self] in
    self?.containerView.show(tab: .friend)
}
containerView.headerView.onChatButtonTapped = { [weak self] in
    self?.containerView.show(tab: .chat)
}

// 其他按鈕
containerView.headerView.onATMButtonTapped = { [weak self] in
    AlertUtils.showAlert(on: self, title: "ATM", message: "onATMButtonTapped")
}

// 內容區域事件
containerView.onAddFriendTapped = { [weak self] in
    AlertUtils.showAlert(on: self, title: "加好友", message: "onAddFriendTapped")
}
```

### ContainerView Tab 管理
```swift
public func show(tab: HeaderView.TabType) {
    friendView.isHidden = (tab != .friend)
    chatView.isHidden = (tab != .chat)
}
```

## 🔄 未來擴展考慮

### MVVM 資料綁定（待實作）
```
ViewModel → ViewController → UI Components
```

### 搜尋功能（待實作）
```
HeaderView.SearchBar → ViewController → ViewModel → Filtered Data
```

### 狀態管理（待實作）
```
Empty State → Friends Only → Friends with Invitations
```

## 📝 備註

- 目前專注於 UI 基礎建設
- 使用方案 A（直接方法呼叫）而非方案 B（屬性綁定）
- 符合當前需求，避免過度設計
- 為未來 MVVM 和 Combine 實作預留擴展空間 