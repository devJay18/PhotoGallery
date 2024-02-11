//
//  LikedImageViewUITests.swift
//  PhotoGalleryUITests
//
//  Created by apple on 12/02/24.
//

import XCTest

final class LikedImageViewUITests: XCTestCase {
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false
        
        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }
    
    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testLikedImageList() throws {
        // UI tests must launch the application that they test.
        let app = XCUIApplication()
        app.launch()
        let tablesQuery = app.tables
        let table = tablesQuery.children(matching: .cell).element(boundBy: 1)
        let likeButton = table.buttons["LikeButton"]
        likeButton.tap()
        let likedButton = app.navigationBars.buttons.element(boundBy: 0)
        likedButton.tap()
        sleep(2)
        app.tables.element.swipeUp()
        sleep(2)
        
    }
}
