//
//  OfflineMessageQueueManagerTests.swift
//  ChatApp
//
//  Created by Naval Hasan on 24/04/25.
//

import XCTest
@testable import ChatApp

final class OfflineMessageQueueManagerTests: XCTestCase {
    func testAddMessage_ShouldQueueIt() {
        let message = Message(sender: "You", content: "Hello")
        OfflineMessageQueueManager.shared.addMessage(message)
        XCTAssertEqual(OfflineMessageQueueManager.shared.queuedMessages.count, 1)
    }
}
