//
//  WebSocketManagerTests.swift
//  ChatApp
//
//  Created by Naval Hasan on 24/04/25.
//

import XCTest
@testable import ChatApp

// This test will succeed only if socket is connected
final class WebSocketManagerTests: XCTestCase {
    func testConnect_ShouldSetIsConnected() {
        let manager = WebSocketManager()
        manager.connectWebSocket()
        XCTAssertTrue(manager.isConnected)
    }
}
