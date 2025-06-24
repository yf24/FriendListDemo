    # 好友頁面整體架構設計（以 MainTab/VC/VM 為主）

## 📋 需求概述

- 多 Tab（主頁、好友、聊天、設定等），以 MainTabBarController 為入口。
- 好友頁（FriendPageViewController）負責好友/聊天列表、邀請、用戶資訊等。
- MVVM 架構，資料流與事件流分離，UI/資料/事件高度解耦。

---

## 🏗️ 架構層級（主流程）

```
MainTabBarController
└── FriendPageViewController (VC)
    ├── FriendPageViewModel (VM)
    └── FriendContainerView (內容管理)
        ├── FriendHeaderView (靜態 header)
        │   ├── User Info
        │   ├── FriendInviteCardView
        │   ├── FriendInviteCardExpandView
        │   └── Tab Buttons
        └── Content Views
            ├── FriendView (好友列表)
            └── ChatView (聊天列表)
```

---

## 🔄 事件與資料流

### 1. Tab Bar 切換
- MainTabBarController 控制 tab 切換，切換到好友頁時載入 FriendPageViewController。

### 2. VC 與 VM
- FriendPageViewController 持有 FriendPageViewModel，負責 UI 綁定、事件轉發、資料流管理。
- VC 訂閱 VM 的 @Published 屬性（user、friends、invitations 等），自動刷新 UI。

### 3. UI 組件事件
- HeaderView、FriendView、ChatView 事件（如按鈕、下拉刷新）用 Combine publisher/closure 往上拋到 VC。
- VC 統一處理所有事件，並呼叫 VM 執行資料操作。

### 4. VM 資料操作
- VM 負責所有資料取得、狀態切換、資料合併、搜尋、邀請同意/拒絕等邏輯。
- VM 只 expose @Published 屬性，UI 不直接操作 Model。

### 5. UI 更新
- VC 訂閱 VM 的資料流，收到新資料自動呼叫 ContainerView/FriendView/ChatView 的 update 方法刷新畫面。

---

## 🎯 設計原則

1. **責任分離**  
   - MainTabBarController：全域 tab 管理
   - FriendPageViewController：UI/事件協調、資料流管理
   - FriendPageViewModel：資料取得、狀態管理、商業邏輯
   - ContainerView/HeaderView/FriendView/ChatView：單純 UI 呈現與事件拋出

2. **事件驅動**  
   - 所有互動事件都用 Combine publisher/closure 往上拋，VC 統一處理。

3. **資料單向流動**  
   - VM → VC → UI，UI 不直接改資料，所有狀態變動都回到 VM。

4. **型別安全、可維護**  
   - Model struct 盡量 immutable，資料變動用新 struct 替換。
   - VM 層統一管理所有資料與狀態。

---

## 🖥️ 主要程式碼結構

### MainTabBarController
- 管理多個 tab，切換時載入對應 VC。

### FriendPageViewController
- 持有 viewModel
- 訂閱 viewModel 的 @Published 屬性
- 處理所有 UI 事件（header、content、cell、邀請等）
- 呼叫 viewModel 執行資料操作

### FriendPageViewModel
- @Published user、friends、invitations、filteredFriends 等
- 提供 loadData、acceptInvitation、declineInvitation 等方法
- 處理所有資料流、狀態切換、搜尋、合併等邏輯

### FriendContainerView
- 管理 headerView、friendView、chatView
- 提供 updateFriendsAndInvitations、show(tab:) 等方法

### FriendHeaderView
- 顯示用戶資訊、邀請卡（含展開狀態）、tab 按鈕
- 事件用 publisher/closure 往上拋

### FriendView/ChatView
- 顯示好友/聊天列表
- 事件（如下拉刷新、cell 按鈕）往上拋

---

## 🔄 事件/資料流範例

```
[UI 事件] → FriendHeaderView.eventPublisher
         → FriendPageViewController
         → viewModel.acceptInvitation(for:)
         → @Published friends/invitations
         → VC 訂閱自動刷新 UI
```

---

## 📝 備註與擴展

- 所有 UI 元件皆用 XIB/code，不用 Storyboard。
- VM 層可輕鬆擴充 API、資料合併、搜尋、排序等功能。
- UI/資料/事件高度解耦，方便維護與單元測試。
- 未來可直接支援 Combine/SwiftUI 資料流。

---

## 🔥 架構圖（主流程）

```mermaid
graph TD
    MainTabBarController --> FriendPageViewController
    FriendPageViewController --> FriendPageViewModel
    FriendPageViewController --> FriendContainerView
    FriendContainerView --> FriendHeaderView
    FriendContainerView --> FriendView
    FriendContainerView --> ChatView
    FriendHeaderView -->|eventPublisher| FriendPageViewController
    FriendView -->|eventPublisher| FriendContainerView
    FriendContainerView -->|eventPublisher| FriendPageViewController
    FriendPageViewModel -->|@Published| FriendPageViewController
```

---

# （以下保留原有細節與未來擴展備註）

## UI 架構層級（細節）

```
FriendPageViewController (容器)
└── ContainerView (內容管理)
    ├── HeaderView (靜態容器)
    │   ├── User Info (獨立)
    │   │   ├── Avatar Button
    │   │   ├── Name Label
    │   │   └── KOKO ID Button
    │   ├── FriendInviteCardExpandView (展開狀態)
    │   │   └── FriendInviteCardView (邀請卡片)
    │   └── Tab Buttons
    │       ├── Friend Button
    │       └── Chat Button
    └── Content Views (動態內容)
        ├── FriendView (好友列表)
        │   ├── UITableView (header: FriendListHeaderView, cell: FriendListCell)
        │   └── EmptyStateView (空狀態)
        └── ChatView (聊天列表)
            └── ChatListView (聊天列表)
```

## 事件流程（細節）

### Tab 切換流程
```
HeaderView.FriendButton → ViewController → ContainerView.show(tab: .friend)
HeaderView.ChatButton → ViewController → ContainerView.show(tab: .chat)
```

### 內容區域事件
```
FriendView.onAddFriendTapped → ContainerView → ViewController
FriendView.onSetKokoIdLabelTapped → ContainerView → ViewController
FriendView.onTransferTapped → ContainerView → ViewController
FriendView.onInviteTapped → ContainerView → ViewController
FriendView.onMoreTapped → ContainerView → ViewController
```

## 未來擴展考慮
- MVVM 資料綁定、搜尋功能、狀態管理等皆可彈性擴充
- 保持架構彈性，避免過度設計

## 📝 備註

- 符合當前需求，避免過度設計