//
//  UITestHelper.swift
//  PhotoGalleryUITests
//
//  Created by apple on 11/02/24.
//

import Foundation
import XCTest

class UITestHelper: XCTestCase {
    let app = XCUIApplication()
    
    func tapKey(withKey: String) {
        app.keys[withKey].tap()
    }
    func alertTapped() {
        let alert = app.alerts.scrollViews.otherElements.buttons["Ok"]
        waitForElementToAppear(element: alert)
        alert.tap()
        sleep(2)
    }
    func waitForElementToAppear(
        element: XCUIElement,
        timeout: TimeInterval = 10,
        file: String = #file,
        line: UInt = #line
    ) {
        let existsPredicate = NSPredicate(format: "exists == true")
        expectation(for: existsPredicate,
                    evaluatedWith: element, handler: nil)
        waitForExpectations(timeout: timeout) { (error) -> Void in
            if error != nil {
                let message = "Failed to find \(element) after \(timeout) seconds."
                self.recordFailure(
                    withDescription: message,
                    inFile: file,
                    atLine: Int(line),
                    expected: true
                )
            }
        }
    }
}
