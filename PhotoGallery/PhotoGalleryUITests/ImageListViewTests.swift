//
//  PhotoGalleryUITests.swift
//  PhotoGalleryUITests
//
//  Created by apple on 10/02/24.
//

import XCTest

final class ImageListViewTests: XCTestCase {
    let app = XCUIApplication()

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.

        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false

    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testImagesList() {
        app.launch()
        sleep(2)
        let tablesQuery = app.tables
        let table = tablesQuery.children(matching: .cell).element(boundBy: 1)
        let likeButton = table.buttons["LikeButton"]
        likeButton.tap()
        sleep(2)
        likeButton.tap()
        sleep(2)
        app.tables.element.swipeUp()
        sleep(2)
        let cell = tablesQuery.children(matching: .cell).element(boundBy: 3)
        XCTAssertTrue(cell.exists)
        sleep(2)
        cell.buttons["LikeButton"].tap()
        sleep(2)
        cell.tap()
        sleep(2)
    }
}
extension XCUIElement
{
    enum SwipeDirection {
        case left, right
    }

    func longSwipe(_ direction : SwipeDirection) {
        let startOffset: CGVector
        let endOffset: CGVector

        switch direction {
        case .right:
            startOffset = CGVector.zero
            endOffset = CGVector(dx: 0.6, dy: 0.0)
        case .left:
            startOffset = CGVector(dx: 0.6, dy: 0.0)
            endOffset = CGVector.zero
        }

        let startPoint = self.coordinate(withNormalizedOffset: startOffset)
        let endPoint = self.coordinate(withNormalizedOffset: endOffset)
        startPoint.press(forDuration: 0, thenDragTo: endPoint)
    }
}
