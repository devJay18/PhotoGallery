//
//  DetailViewUITests.swift
//  PhotoGalleryUITests
//
//  Created by apple on 11/02/24.
//

import XCTest
import Photos

final class DetailViewUITests: XCTestCase {

    let helper = UITestHelper()
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.

        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() throws {
        // UI tests must launch the application that they test.
        let app = XCUIApplication()
        app.launch()
        sleep(2)
        let tablesQuery = app.tables
        let table = tablesQuery.children(matching: .cell).element(boundBy: 1)
        table.tap()
        sleep(2)
        let logoutButton = app.navigationBars.buttons.element(boundBy: 0)
        logoutButton.tap()
        sleep(2)
        table.tap()
        sleep(2)
        if checkPhotoLibraryPermission() {
            let saveButton = app.staticTexts["Save"]
            saveButton.tap()
            sleep(2)
            helper.alertTapped()
            sleep(2)
        }
        let deleteButton = app.staticTexts["Delete "]
        deleteButton.tap()
        sleep(2)
        helper.alertTapped()
    }
    func checkPhotoLibraryPermission() -> Bool {
        let status = PHPhotoLibrary.authorizationStatus()
        switch status {
        case .authorized:
            return true
        case .denied, .restricted:
            return false
        case .notDetermined:
            return false
        @unknown default:
            return false
        }
    }
}
