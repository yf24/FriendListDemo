//
//  UnderlineModifier.swift
//  FriendListDemo
//
//  Created by TWIPC00587031E on 2025/12/5.
//

import SwiftUI

extension View {
    func applyUnderline(isSelected: Bool) -> some View {
        modifier(UnderlineModifier(isSelected: isSelected))
    }
}

struct UnderlineModifier: ViewModifier {
    let isSelected: Bool
    
    func body(content: Content) -> some View {
        content
            .overlay(alignment: .bottom) {
                if isSelected {
                    Rectangle()
                        .foregroundColor(.clear)
                        .frame(width: 20, height: 4)
                        .background(.hotPink)
                        .cornerRadius(2.0)
                }
            }
    }
}


// MARK: - Preview

#Preview {
    Button(action: {}) {
        Text("Text")
            .font(.system(size: 13, weight: .medium))
            .frame(width: 50, height: 40)
    }
    .frame(width: 50, height: 40)
//    .border(.gray)
    .applyUnderline(isSelected: true)
}
