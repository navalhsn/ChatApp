//
//  ChatDetailView.swift
//  ChatApp
//
//  Created by Naval Hasan on 23/04/25.
//
import SwiftUI

struct ChatDetailView: View {
    @State var chat: Chat
    @StateObject private var viewModel = ChatViewModel()

    var body: some View {
        VStack {
            List(viewModel.messages) { message in
                HStack {
                    if message.sender == "You" {
                        Spacer()
                        Text(message.content)
                            .padding()
                            .background(Color.blue.opacity(0.3))
                            .cornerRadius(10)
                    } else {
                        Text(message.content)
                            .padding()
                            .background(Color.gray.opacity(0.2))
                            .cornerRadius(10)
                        Spacer()
                    }
                }
            }
            .listStyle(PlainListStyle())

            HStack {
                TextField("Type a message", text: $viewModel.inputText)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                Button("Send") {
                    viewModel.sendMessage()
                }
            }
            .padding()
        }
        .navigationTitle("ChatBot")
        .onAppear {
            // Reload the messages when the detail view appears
            viewModel.checkNetworkConnection()
        }
        .alert(isPresented: $viewModel.noConnection) {
            Alert(title: Text("No Internet Connection"), message: Text("Please check your network connection."), dismissButton: .default(Text("OK")))
        }
        .onDisappear {
            viewModel.disconnectWebSocket()
        }
    }
}

struct ChatDetailView_Previews: PreviewProvider {
    static var previews: some View {
        // Creating a mock chat object
        let mockChat = Chat(botName: "SupportBot", messages: [
            Message(sender: "You", content: "Hi, I need help with my order."),
            Message(sender: "Bot", content: "Sure! What seems to be the issue?")
        ])
        // Preview the ChatDetailView
        ChatDetailView(chat: mockChat)
            .previewLayout(.sizeThatFits)
            .padding()
    }
}
