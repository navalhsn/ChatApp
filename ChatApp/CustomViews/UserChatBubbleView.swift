//
//  UserChatBubbleView.swift
//  ChatApp
//
//  Created by Naval Hasan on 24/04/25.
//
import SwiftUI

struct UserChatBubbleView: View {
    let message: String
    var body: some View {
        HStack {
            Image("user_temp")
            
            Text(message)
                .customFont(size: 15, weight: .medium, color: Color("TextSecondary"))
                .padding(.vertical, 15)
            Spacer()
        }
        .padding(.horizontal, 15)
        .background(.clear)
        .cornerRadius(8)
        .overlay(
            RoundedRectangle(cornerRadius: 8)
                .inset(by: 0.5)
                .stroke(Color("PrimaryIcon"), lineWidth: 1)
        )
    }
}

#Preview {
    UserChatBubbleView(message: "test")
}
