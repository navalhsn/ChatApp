//
//  ChatListView.swift
//  ChatApp
//
//  Created by Naval Hasan on 23/04/25.
//
import SwiftUI

struct ChatListView: View {
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
        .alert(item: $viewModel.errorMessage) { alert in
            Alert(title: Text("Error"), message: Text(alert.message), dismissButton: .default(Text("OK")))
        }
        .onDisappear {
            viewModel.disconnectWebSocket()
        }
    }
}

struct ChatListView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            ChatListView()
        }
    }
}
