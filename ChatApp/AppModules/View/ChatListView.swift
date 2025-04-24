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
                                VStack {
                                    HStack {
                                        VStack {
                                            Text(chat.botName)
                                                .customFont(size: 15, weight: .bold, color: Color("TextSecondary"))
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
