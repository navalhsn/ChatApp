//
//  ChatListView.swift
//  ChatApp
//
//  Created by Naval Hasan on 23/04/25.
//
import SwiftUI

struct ChatListView: View {
    @StateObject private var viewModel = ChatViewModel()
    private let webSocketManager = WebSocketManager()
    
    var body: some View {
        ZStack {
            Color("PrimaryBackground")
                .edgesIgnoringSafeArea(.all)
            
            VStack {
                if viewModel.chats.isEmpty {
                    Text("No chats available")
                        .padding()
                } else {
                    Text("Chats")
                        .customFont(size: 31, weight: .bold, color: Color("PrimaryFont"))
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.top)
                        .padding(.horizontal)
                    
                    ScrollView {
                        ForEach(viewModel.chats, id: \.self) { chat in
                            NavigationLink(destination: ChatDetailView(chat: chat)) {
                                VStack {
                                    HStack {
                                        VStack {
                                            Text(chat.botName)
                                                .customFont(size: 15, weight: .bold, color: Color("PrimaryFont"))
                                                .frame(maxWidth: .infinity, alignment: .leading)
                                            Spacer()
                                            Text(chat.latestMessage)
                                                .foregroundColor(.gray)
                                                .frame(maxWidth: .infinity, alignment: .leading)
                                        }
                                        
                                        Image(systemName: "arrow.right")
                                            .font(.system(size: 24))
                                            .foregroundColor(Color("PrimaryIcon"))
                                    }
                                    
                                    Divider()
                                        .frame(height: 2)
                                        .frame(maxWidth: .infinity)
                                        .background(Color("Divider"))
                                }
                                .frame(height: 50)
                                .padding(.vertical, 5)
                            }
                        }
                    }.padding(.horizontal)
                    
                }
            }
            .alert(item: $viewModel.errorMessage) { alert in
                Alert(title: Text("Error"), message: Text(alert.message), dismissButton: .default(Text("OK")))
            }
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
