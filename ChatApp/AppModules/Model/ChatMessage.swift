//
//  ChatMessage.swift
//  ChatApp
//
//  Created by Naval Hasan on 23/04/25.
//
import Foundation

// MARK: - Message Model
struct Message: Identifiable, Codable, Hashable {
    var id = UUID()
    let sender: String
    let content: String
    var timestamp: Date = Date()
    var isQueued: Bool = false
}

// MARK: - Chat Model
struct Chat: Identifiable, Hashable {
    let id = UUID()
    let botName: String
    var messages: [Message] = []
    var isQueued: Bool = false
    var latestMessage: String {
        return messages.last?.content ?? "No messages yet"
    }
}

// MARK: - IdentifiableAlert
struct IdentifiableAlert: Identifiable {
    var id: String { message }
    let message: String
}
