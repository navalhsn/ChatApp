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
    @Published var isConnected: Bool = false
    @Published var errorMessage: IdentifiableAlert?
    @Published var chats: [Chat] = []
    @Published var noConnection: Bool = false
    private var webSocketTask: URLSessionWebSocketTask?
    private var cancellables = Set<AnyCancellable>()
    private let offlineQueueManager = OfflineMessageQueueManager()
    private let webSocketManager = WebSocketManager()
    
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
        
        connectWebSocket()
    }
    
    func connectWebSocket() {
        let session = URLSession(configuration: .default)
        webSocketTask = session.webSocketTask(with: webSocketManager.webSocketURL)
        webSocketTask?.resume()
        isConnected = true
        receiveMessage()
        
        // Attempt to retry queued messages when reconnected
        offlineQueueManager.retryMessagesIfConnected(isConnected: isConnected, sendMessage: sendMessageDirectly)
    }
    
    func disconnectWebSocket() {
        webSocketTask?.cancel(with: .goingAway, reason: nil)
        isConnected = false
    }
    
    func checkNetworkConnection() {
        if !isConnected {
            noConnection = true
        } else {
            noConnection = false
            // Retry messages on reconnection
            offlineQueueManager.retryMessagesIfConnected(isConnected: isConnected, sendMessage: sendMessageDirectly)
        }
    }
    
    func sendMessage() {
        guard !inputText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else { return }
        
        let newMessage = Message(sender: "You", content: inputText)
        messages.append(newMessage)
        
        let message = URLSessionWebSocketTask.Message.string(inputText)
        webSocketTask?.send(message) { [weak self] error in
            if let error = error {
                DispatchQueue.main.async {
                    self?.errorMessage = IdentifiableAlert(message: "Failed to send message: \(error.localizedDescription)")
                }
            }
        }
        
        if isConnected {
            sendMessageDirectly(newMessage)
        } else {
            // Now actually using OfflineMessageQueueManager
            offlineQueueManager.addMessage(newMessage)
        }
        
        inputText = ""
    }
    
    private func receiveMessage() {
        webSocketTask?.receive { [weak self] result in
            switch result {
            case .failure(let error):
                DispatchQueue.main.async {
                    self?.errorMessage = IdentifiableAlert(message: "Failed to receive message: \(error.localizedDescription)")
                }
            case .success(let message):
                switch message {
                case .string(let text):
                    let newMessage = Message(sender: "Bot", content: text)
                    DispatchQueue.main.async {
                        self?.messages.append(newMessage)
                    }
                default:
                    break
                }
            }
            self?.receiveMessage()
        }
    }
    
    private func sendMessageDirectly(_ message: Message) {
        let webMessage = URLSessionWebSocketTask.Message.string(message.content)
        webSocketTask?.send(webMessage) { [weak self] error in
            if let error = error {
                DispatchQueue.main.async {
                    self?.errorMessage = IdentifiableAlert(message: "Failed to send message: \(error.localizedDescription)")
                }
            }
        }
    }
}
