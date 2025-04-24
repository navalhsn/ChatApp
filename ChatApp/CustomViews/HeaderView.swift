//
//  HeaderView.swift
//  ChatApp
//
//  Created by Naval Hasan on 24/04/25.
//
import SwiftUI

struct HeaderView: View {
    var headText: String
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        HStack() {
            if headText != "" {
                Button(action: {
                    dismiss()
                }) {
                    Image("back_button")
                }
                .padding(.leading, 24)
            }
            
            Text(headText).customFont(size: 19, weight: .semibold)
            
            Spacer()
            
        }
        .background(.clear)
        .cornerRadius(16)
    }
}

#Preview {
    HeaderView(headText: "Chat View")
}
