//
//  ChatMessage.swift
//  ChatApp
//
//  Created by Naval Hasan on 23/04/25.
//
import Foundation

// MARK: - Chat Model
struct Chat: Identifiable, Hashable {
    let id = UUID()
    let botName: String
    var messages: [Message] = []
    var latestMessage: String {
        return messages.last?.content ?? "No messages yet"
    }
    var unreadCount: Int {
        return messages.filter { !$0.isQueued }.count
    }
}

// MARK: - Message Model
struct Message: Identifiable, Codable, Hashable {
    var id = UUID()
    let sender: String
    let content: String
    var timestamp: Date = Date()
    var isQueued: Bool = false
}


// MARK: - IdentifiableAlert
struct IdentifiableAlert: Identifiable {
    var id: String { message }
    let message: String
}
