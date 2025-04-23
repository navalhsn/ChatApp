//
//  ChatPreview.swift
//  ChatApp
//
//  Created by Naval Hasan on 23/04/25.
//
import Foundation

struct ChatPreview: Identifiable {
    let id = UUID()
    let botName: String
    let lastMessage: String
    let unread: Bool
}
