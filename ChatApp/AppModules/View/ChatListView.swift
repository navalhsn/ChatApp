//
//  ChatListView.swift
//  ChatApp
//
//  Created by Naval Hasan on 23/04/25.
//
import SwiftUI

struct ChatListView: View {
    @State var shouldNavigate: Bool = false
    private let webSocketManager = WebSocketManager()
    @State var selectedChatIndex: Int = 0
    
    var body: some View {
        ZStack {
            Color("PrimaryBackground")
                .edgesIgnoringSafeArea(.all)
                .allowsHitTesting(false)
            
            VStack {
                if ChatManager.shared.chats.isEmpty {
                    Text("No chats available")
                        .padding()
                } else {
                    Text("Chats")
                        .customFont(size: 31, weight: .bold, color: Color("TextSecondary"))
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.top)
                        .padding(.horizontal)
                    
                    ScrollView {
                        ForEach(ChatManager.shared.chats, id: \.self) { chat in
                            Button(action: {
                                ChatManager.shared.currentChat = chat
                                self.shouldNavigate = true
                            }, label: {
                                ListCellView(botName: chat.botName, message: chat.latestMessage)
                            })
                            .frame(height: 55)
                            .padding(.vertical, 5)
                        }
                    }.padding(.horizontal)
                    
                }
            }
            .navigationDestination(isPresented: $shouldNavigate) {
                ChatDetailView()
            }
        }
        .withWebSocketAlerts(webSocketManager)
    }
}

struct ChatListView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            ChatListView()
        }
    }
}
