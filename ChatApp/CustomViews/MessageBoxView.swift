//
//  MessageBoxView.swift
//  ChatApp
//
//  Created by Naval Hasan on 24/04/25.
//
import SwiftUI

struct MessageBoxView: View {
    var sendButtonAction: () -> ()
    @Binding var sendMessage: String
    
    var body: some View {
        HStack {
            HStack {
                TextField("Type your query...", text: $sendMessage, onEditingChanged: { editing in withAnimation {}})
                
                Spacer()
                
                Button(action: {
                    sendButtonAction()
                }) {
                    Image("send_icon")
                        .foregroundColor(.gray)
                        .padding(.trailing, 4)
                }
            }
            .padding(.vertical, 18)
            .padding(.leading, 24)
            .padding(.trailing, 20)
            .background(Color("BgSecondary"))
            .cornerRadius(24)
            .overlay(
                RoundedRectangle(cornerRadius: 30)
                    .stroke(Color("BorderPrimary"), lineWidth: 1))
            .cornerRadius(30)
        }
    }
    
}
