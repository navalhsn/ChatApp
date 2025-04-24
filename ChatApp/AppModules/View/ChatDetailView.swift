//
//  ChatDetailView.swift
//  ChatApp
//
//  Created by Naval Hasan on 23/04/25.
//
import SwiftUI

struct ChatDetailView: View {
    @State var chat: Chat
    @ObservedObject private var viewModel = ChatViewModel()
    
    var body: some View {
        ZStack {
            Color("PrimaryBackground")
                .edgesIgnoringSafeArea(.all)
            
            VStack(spacing: 0) {
                ScrollView {
                    ForEach(viewModel.messages, id: \.self) { message in
                        HStack {
                            if message.sender == "You" {
                                Spacer()
                                Text(message.content)
                                    .customFont(size: 15, weight: .bold, color: Color("PrimaryFont"))
                                    .padding()
                                    .background(Color.blue.opacity(0.3))
                                    .cornerRadius(10)
                            } else {
                                Text(message.content)
                                    .customFont(size: 15, weight: .bold, color: Color("PrimaryFont"))
                                    .padding()
                                    .background(Color.gray.opacity(0.2))
                                    .cornerRadius(10)
                                Spacer()
                            }
                        }
                    }
                }
                
                HStack {
                    TextField("Type a message", text: $viewModel.inputText)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                    Button("Send") {
                        viewModel.webSocketManager.sendMessage(inputText: viewModel.inputText)
                    }
                }
                .padding()
            }            
        }
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



struct UserChatBubble: View {
    let message: String
    var body: some View {
        HStack {
            Text(message)
                .font(.system(size: 14, weight: .regular))
                .foregroundColor(.textPrimary)
                .padding(12)
            
            Spacer()
            
            Image("user_temp")
                .padding(.horizontal, 10)
        }
        .background(.clear)
        .cornerRadius(8)
        .overlay(
            RoundedRectangle(cornerRadius: 8)
                .inset(by: 0.5)
                .stroke(.borderPrimary, lineWidth: 1)
        )
    }
}

struct SystemChatBubble: View {
    let message: String
    var body: some View {
        HStack {
            Spacer()
            Text(message)
                .font(.system(size: 14, weight: .regular))
                .foregroundColor(Color("TextPrimary"))
                .frame(maxWidth: .infinity, alignment: .topLeading)
                .padding(.horizontal ,8)
                .padding(.vertical ,12)
        }
        .background(Color("BgSecondary"))
        .cornerRadius(8)
    }
}

struct MessageBox: View {
    var sendButtonAction: () -> ()
    var justHaveButtonAction: () -> ()
    var cameraButtonAction: () -> ()
    @Binding var sendMessage: String
    
    var body: some View {
        HStack {
            Button(action: {
                justHaveButtonAction()
            }) {
                Image("just_have_icon")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 50, height: 50)
            }
            
            Button(action: {
                cameraButtonAction()
            }) {
                Image("camera_icon")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 50, height: 50)
            }
            
            HStack {
                TextField("I only have apples", text: $sendMessage, onEditingChanged: { editing in
                    withAnimation {
                    }
                })
                
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
