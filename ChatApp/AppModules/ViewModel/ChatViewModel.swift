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
        // Dummy data initialization for chats
        let dummyChats = [
            Chat(botName: "SupportBot", messages: [
                Message(sender: "You", content: "Hi, I need help with my order."),
                Message(sender: "Bot", content: "Sure! What seems to be the issue?")
            ]),
            Chat(botName: "SalesBot", messages: [
                Message(sender: "You", content: "I'd like to know more about your products."),
                Message(sender: "Bot", content: "We offer a range of products. What are you looking for?")
            ]),
            Chat(botName: "FAQBot", messages: [
                Message(sender: "You", content: "How can I reset my password?"),
                Message(sender: "Bot", content: "You can reset your password through the settings page.")
            ])
        ]
        
        self.chats = dummyChats
        
        let sampleMessages = [
            Message(sender: "You", content: "Hello!"),
            Message(sender: "Bot", content: "Hi there! How can I assist you?")
        ]
        messages = sampleMessages
        
        webSocketManager.connectWebSocket()
        
        webSocketManager.$messages
                    .receive(on: DispatchQueue.main)
                    .sink { [weak self] updatedMessages in
                        self?.messages = updatedMessages
                    }.store(in: &cancellables)
    }
}
