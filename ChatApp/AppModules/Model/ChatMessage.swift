//
//  ChatMessage.swift
//  ChatApp
//
//  Created by Naval Hasan on 23/04/25.
//
import Foundation

// MARK: - Message Model
struct Message: Identifiable, Codable {
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
