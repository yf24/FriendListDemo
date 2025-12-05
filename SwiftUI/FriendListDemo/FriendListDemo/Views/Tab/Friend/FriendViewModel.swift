//
//  FriendViewModel.swift
//  FriendListDemo
//
//  Created by TWIPC00587031E on 2025/12/3.
//

import Combine

class FriendViewModel: ObservableObject {
    let actionSubject = PassthroughSubject<FriendHeaderView.Action, Never>()
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        actionSubject
            .sink { [weak self] action in
                self?.handle(action)
            }
            .store(in: &cancellables)
    }
    
    private func handle(_ action: FriendHeaderView.Action) {
        switch action {
        case .atmTap:
            print("atmTap")
        case .transferTap:
            print("transferTap")
        case .scanTap:
            print("scanTap")
        case .avatarTap:
            print("avatarTap")
        case .kokoIdTap:
            print("kokoIdTap")
        case .friendTap:
            print("friendTap")
        case .chatTap:
            print("chatTap")
        }
    }
}
