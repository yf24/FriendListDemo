//
//  BadgeModifier.swift
//  FriendListDemo
//
//  Created by TWIPC00587031E on 2025/12/5.
//

import SwiftUI

extension View {
    func applyBadge(count: Int) -> some View {
        modifier(BadgeModifier(count: count))
    }
}

struct BadgeModifier: ViewModifier {
    let count: Int
    private let badgeHeight: CGFloat = 18
    
    func body(content: Content) -> some View {
        content
            .overlay(alignment: .topLeading) {
                if count > 0 {
                    GeometryReader { geo in
                        badgeLabel
                            .offset(
                                x: geo.size.width - 9.5,
                                y: -6 + badgeHeight/2
                            )
                    }
                }
            }
    }
    
    private var badgeLabel: some View {
        Text(count >= 99 ? "99+" : "\(count)")
            .font(.system(size: 12))
            .foregroundColor(.white)
            .padding(.horizontal, 6)
            .frame(height: badgeHeight)
            .background(.veryLightPink)
            .clipShape(Capsule())
    }
}


// MARK: - Preview

#Preview {
    HStack(spacing: 9) {
        Button(action: {}) {
            Text("Text1")
                .font(.system(size: 13, weight: .medium))
                .frame(width: 50, height: 40)
                .applyBadge(count: 1)
        }
//        .border(.gray)
        
        Button(action: {}) {
            Text("Text2")
                .font(.system(size: 13, weight: .medium))
                .frame(width: 50, height: 40)
                .applyBadge(count: 99)
        }
//        .border(.gray)
    }
}
