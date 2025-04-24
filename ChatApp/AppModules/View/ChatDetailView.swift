//
//  ChatDetailView.swift
//  ChatApp
//
//  Created by Naval Hasan on 23/04/25.
//
import SwiftUI

struct ChatDetailView: View {
    @State var chat: Chat?
    @ObservedObject var viewModel: ChatViewModel
    
    var body: some View {
        ZStack {
            Color("PrimaryBackground")
                .edgesIgnoringSafeArea(.all)
            
            VStack(spacing: 0) {
                HeaderView(headText: chat?.botName ?? "Bot")
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
            // Reload the messages when the detail view appears
            viewModel.webSocketManager.checkNetworkConnection()
        }
        .alert(isPresented: Binding(get: { viewModel.webSocketManager.noConnection }, set: { viewModel.webSocketManager.noConnection = $0 })) {
            Alert(title: Text("No Internet Connection"), message: Text("Please check your network connection."), dismissButton: .default(Text("OK")))
        }
        .onDisappear {
            viewModel.webSocketManager.disconnectWebSocket()
        }
    }
}

#Preview {
    let sampleMessages = [
        Message(sender: "You", content: "Hello!"),
        Message(sender: "Bot", content: "Hi there! How can I assist you?")
    ]
    let sampleChat = Chat(botName: "SupportBot", messages: sampleMessages)
    let sampleViewModel = ChatViewModel()
    sampleViewModel.messages = sampleMessages
    return ChatDetailView(chat: sampleChat, viewModel: sampleViewModel)
}
