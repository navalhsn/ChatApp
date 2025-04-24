//
//  SystemChatBubbleView.swift
//  ChatApp
//
//  Created by Naval Hasan on 24/04/25.
//
import SwiftUI

struct SystemChatBubbleView: View {
    let message: String
    var body: some View {
        HStack {
            Spacer()
            Text(message)
                .customFont(size: 15, weight: .medium, color: Color("TextSecondary"))
                .padding(.vertical, 15)
            
            Image("chatbot")
                .resizable()
                .frame(width: 20, height: 20)
        }
        .padding(.horizontal, 15)
        .background(Color.gray.opacity(0.2))
        .cornerRadius(8)
    }
}

#Preview {
    SystemChatBubbleView(message: "test")
}
