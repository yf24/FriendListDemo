//
//  FriendListDemoTests.swift
//  FriendListDemoTests
//
//  Created by Ming on 2025/6/13.
//

import Testing
import Foundation
@testable import FriendListDemo

struct FriendListDemoTests {

    // MARK: - Friend Model
    @Test func testFriendInit() async throws {
        let date = Date.from("20231115")
        let friend = Friend(name: "小明", status: .completed, isTop: true, fid: "abc123", updateDate: date)
        #expect(friend.name == "小明")
        #expect(friend.status == .completed)
        #expect(friend.isTop == true)
        #expect(friend.fid == "abc123")
        #expect(friend.updateDate == date)
    }

    @Test func testFriendCodable() async throws {
        let date = Date.from("20231116")
        let friend = Friend(name: "小華", status: .inviting, isTop: false, fid: "def456", updateDate: date)
        let encoder = JSONEncoder()
        let data = try encoder.encode(friend)
        let decoder = JSONDecoder()
        let decoded = try decoder.decode(Friend.self, from: data)
        #expect(decoded.name == friend.name)
        #expect(decoded.status == friend.status)
        #expect(decoded.isTop == friend.isTop)
        #expect(decoded.fid == friend.fid)
        // 日期精度到天，因為 encode 只保留 yyyyMMdd
        let calendar = Calendar.current
        #expect(calendar.isDate(decoded.updateDate, inSameDayAs: friend.updateDate))
    }

    // MARK: - User Model
    @Test func testUserInit() async throws {
        let user = User(name: "小美", kokoid: "koko123")
        #expect(user.name == "小美")
        #expect(user.kokoid == "koko123")
        let user2 = User(name: "小王", kokoid: nil)
        #expect(user2.name == "小王")
        #expect(user2.kokoid == nil)
    }

    @Test func testUserCodable() async throws {
        let user = User(name: "小美", kokoid: "koko123")
        let encoder = JSONEncoder()
        let data = try encoder.encode(user)
        let decoder = JSONDecoder()
        let decoded = try decoder.decode(User.self, from: data)
        #expect(decoded.name == user.name)
        #expect(decoded.kokoid == user.kokoid)
    }

    // MARK: - ViewModel
    @Test func testViewModelLoadData() async throws {
        let vm = FriendPageViewModel()
        vm.loadData(for: .testData)
        // 等待資料初始化
        try await Task.sleep(nanoseconds: .milliseconds(200))
        #expect(vm.allFriends.count > 0)
        #expect(vm.friends.contains { $0.status == .completed })
        #expect(vm.invitations.contains { $0.status == .inviting })
    }

    @Test func testViewModelAcceptInvitation() async throws {
        let vm = FriendPageViewModel()
        vm.loadData(for: .testData)
        try await Task.sleep(nanoseconds: .milliseconds(200))
        let invitation = vm.invitations.first
        #expect(invitation != nil)
        if let invitation = invitation {
            vm.acceptInvitation(for: invitation)
            // 應該從 invitations 消失，並進入 friends
            #expect(!vm.invitations.contains(where: { $0.fid == invitation.fid }))
            #expect(vm.friends.contains(where: { $0.fid == invitation.fid && $0.status == .completed }))
        }
    }

    @Test func testViewModelDeclineInvitation() async throws {
        let vm = FriendPageViewModel()
        vm.loadData(for: .testData)
        try await Task.sleep(nanoseconds: .milliseconds(200))
        let invitation = vm.invitations.first
        #expect(invitation != nil)
        if let invitation = invitation {
            vm.declineInvitation(for: invitation)
            // 應該從 allFriends/invitations/friends 都消失
            #expect(!vm.allFriends.contains(where: { $0.fid == invitation.fid }))
            #expect(!vm.invitations.contains(where: { $0.fid == invitation.fid }))
            #expect(!vm.friends.contains(where: { $0.fid == invitation.fid }))
        }
    }

}
