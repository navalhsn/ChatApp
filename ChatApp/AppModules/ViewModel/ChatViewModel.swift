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

    private let webSocketURL = URL(string: "wss://s14506.blr1.piesocket.com/v3/1?api_key=h1N726iAoJmOdESuurZiEiQ0Ydt6VRY9bU44nRE2&notify_self=1")!

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
        webSocketTask = session.webSocketTask(with: webSocketURL)
        webSocketTask?.resume()
        isConnected = true
        receiveMessage()
    }

    func disconnectWebSocket() {
        webSocketTask?.cancel(with: .goingAway, reason: nil)
        isConnected = false
    }
    
    func checkNetworkConnection() {
        // Simulate checking network status
        if !isConnected {
            DispatchQueue.main.async {
                self.noConnection = true
            }
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
}

//import Network

//class ChatViewModel: ObservableObject {
//    @Published var chats: [Chat] = []
//    @Published var inputText: String = ""
//    @Published var errorMessage: IdentifiableAlert?
//    @Published var isConnected: Bool = false
//    @Published var noConnection: Bool = false
//
//    private var webSocketTask: URLSessionWebSocketTask?
//    private var networkMonitor: NWPathMonitor?
//    
//    init() {
//        // Dummy data initialization for chats
//        let dummyChats = [
//            Chat(botName: "SupportBot", messages: [
//                Message(sender: "You", content: "Hi, I need help with my order."),
//                Message(sender: "Bot", content: "Sure! What seems to be the issue?")
//            ]),
//            Chat(botName: "SalesBot", messages: [
//                Message(sender: "You", content: "I'd like to know more about your products."),
//                Message(sender: "Bot", content: "We offer a range of products. What are you looking for?")
//            ]),
//            Chat(botName: "FAQBot", messages: [
//                Message(sender: "You", content: "How can I reset my password?"),
//                Message(sender: "Bot", content: "You can reset your password through the settings page.")
//            ])
//        ]
//        
//        self.chats = dummyChats
//        
//        // Attempt to connect the WebSocket here for all chats
//        connectWebSocket()
//        
//        // Start network monitoring
//        startNetworkMonitoring()
//    }
//
//    func connectWebSocket() {
//        guard webSocketTask == nil else { return }
//
//        let webSocketURL = URL(string: "wss://s14506.blr1.piesocket.com/v3/1?api_key=h1N726iAoJmOdESuurZiEiQ0Ydt6VRY9bU44nRE2&notify_self=1")!
//        let session = URLSession(configuration: .default)
//        webSocketTask = session.webSocketTask(with: webSocketURL)
//        webSocketTask?.resume()
//        isConnected = true
//        receiveMessage()
//    }
//
//    func disconnectWebSocket() {
//        webSocketTask?.cancel(with: .goingAway, reason: nil)
//        webSocketTask = nil
//        isConnected = false
//    }
//
//    func sendMessage(to botName: String) {
//        guard !inputText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else { return }
//
//        if let index = chats.firstIndex(where: { $0.botName == botName }) {
//            let newMessage = Message(sender: "You", content: inputText)
//            chats[index].messages.append(newMessage)
//
//            let message = URLSessionWebSocketTask.Message.string(inputText)
//            webSocketTask?.send(message) { [weak self] error in
//                if let error = error {
//                    DispatchQueue.main.async {
//                        self?.errorMessage = IdentifiableAlert(message: "Failed to send message: \(error.localizedDescription)")
//                        // Queue the message if failed
//                        if var lastMessage = self?.chats[index].messages.last {
//                            lastMessage.isQueued = true
//                            self?.chats[index].messages[self?.chats[index].messages.count ?? 0 - 1] = lastMessage
//                        }
//                    }
//                }
//            }
//        }
//
//        inputText = ""
//    }
//
//    func receiveMessage() {
//        webSocketTask?.receive { [weak self] result in
//            switch result {
//            case .failure(let error):
//                DispatchQueue.main.async {
//                    self?.errorMessage = IdentifiableAlert(message: "Failed to receive message: \(error.localizedDescription)")
//                }
//            case .success(let message):
//                switch message {
//                case .string(let text):
//                    if let index = self?.chats.firstIndex(where: { $0.botName == "Bot" }) {
//                        let botMessage = Message(sender: "Bot", content: text)
//                        DispatchQueue.main.async {
//                            self?.chats[index].messages.append(botMessage)
//                        }
//                    }
//                default:
//                    break
//                }
//            }
//            self?.receiveMessage() // Keep listening for messages
//        }
//    }
//
//    func startNetworkMonitoring() {
//        networkMonitor = NWPathMonitor()
//        networkMonitor?.pathUpdateHandler = { [weak self] path in
//            if path.status == .unsatisfied {
//                // Network is not connected
//                DispatchQueue.main.async {
//                    self?.noConnection = true
//                }
//            } else {
//                // Network is connected
//                DispatchQueue.main.async {
//                    self?.noConnection = false
//                    self?.retrySendingFailedMessages()
//                }
//            }
//        }
//        let queue = DispatchQueue(label: "NetworkMonitorQueue")
//        networkMonitor?.start(queue: queue)
//    }
//
//    func retrySendingFailedMessages() {
//        for index in chats.indices {
//            if chats[index].isQueued {
//                for msgIndex in chats[index].messages.indices where chats[index].messages[msgIndex].isQueued {
//                    sendMessage(to: chats[index].botName)
//                    chats[index].messages[msgIndex].isQueued = false
//                }
//            }
//        }
//    }
//    
//    func checkNetworkConnection() {
//        // Simulate checking network status
//        // You can replace this with actual network monitoring logic
//        if !isConnected {
//            DispatchQueue.main.async {
//                self.noConnection = true
//            }
//        }
//    }
//}
