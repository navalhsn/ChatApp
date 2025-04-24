//
//  ChatAppUITests.swift
//  ChatAppUITests
//
//  Created by Naval Hasan on 24/04/25.
//

import XCTest

final class ChatUITests: XCTestCase {

    let app = XCUIApplication()

    override func setUpWithError() throws {
        continueAfterFailure = false
        app.launch()
    }

    func testSendingMessageDisplaysInChat() throws {
        let messageField = app.textFields["MessageInputField"]
        messageField.tap()
        messageField.typeText("Hello from test!")

        app.buttons["SendButton"].tap()

        let messageBubble = app.staticTexts["Hello from test!"]
        XCTAssertTrue(messageBubble.waitForExistence(timeout: 2))
    }
}
