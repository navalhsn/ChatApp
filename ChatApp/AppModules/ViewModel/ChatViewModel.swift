//
//  ChatViewModel.swift
//  ChatApp
//
//  Created by Naval Hasan on 23/04/25.
//
import Foundation
import Combine

class ChatViewModel: ObservableObject {
    @Published var messages: [Message] = []
    @Published var inputText: String = ""
    @Published var chats: [Chat] = []
    let webSocketManager = WebSocketManager()
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        webSocketManager.connectWebSocket()
        setupInitialData() // Move initial data setup to init
        
        // Only add new messages from the WebSocket
        webSocketManager.$messages
            .receive(on: DispatchQueue.main)
            .sink { [weak self] updatedMessages in
                guard let self = self else { return }
                
                // Only add messages that aren't already in the array
                for message in updatedMessages {
                    if !self.messages.contains(where: { $0.id == message.id }) {
                        self.messages.append(message)
                    }
                }
            }.store(in: &cancellables)
    }
    
    func setupInitialData() {
        if let chat = ChatManager.shared.currentChat {
            // Clear existing messages and add preset ones
            messages = chat.messages
            
            // Also update the WebSocket manager's messages to include these preset messages
            webSocketManager.messages = chat.messages
            
            print("chat from vm: ", messages)
        }
    }
}
