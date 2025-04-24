//
//  ChatDetailView.swift
//  ChatApp
//
//  Created by Naval Hasan on 23/04/25.
//
import SwiftUI

struct ChatDetailView: View {
    @StateObject var viewModel = ChatViewModel()
    
    var body: some View {
        ZStack {
            Color("PrimaryBackground")
                .edgesIgnoringSafeArea(.all)
                .allowsHitTesting(false)
            
            VStack(spacing: 0) {
                HeaderView(headText: ChatManager.shared.currentChat?.botName ?? "Bot")
                    .padding(.bottom)
                
                ScrollView {
                    ForEach(viewModel.messages, id: \.self) { message in
                        HStack {
                            if message.sender == "You" {
                                UserChatBubbleView(message: message.content)
                            } else {
                                SystemChatBubbleView(message: message.content)
                            }
                        }
                    }
                }.padding(.horizontal)
                
                MessageBoxView(sendButtonAction: {
                    viewModel.webSocketManager.sendMessage(inputText: viewModel.inputText)
                    viewModel.inputText = ""
                }, sendMessage: $viewModel.inputText)
                .padding()
            }
        }
        .navigationBarHidden(true)
        .onAppear {
            viewModel.setupInitialData()
        }
        .onDisappear {
            viewModel.webSocketManager.disconnectWebSocket()
        }
        .withWebSocketAlerts(viewModel.webSocketManager)
        .withOfflineAlert(viewModel.webSocketManager)
        
    }
}

#Preview {
    ChatDetailView()
}
