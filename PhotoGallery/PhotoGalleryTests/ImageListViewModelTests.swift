//
//  ImageListViewModel.swift
//  PhotoGalleryTests
//
//  Created by apple on 11/02/24.
//

import XCTest
@testable import PhotoGallery

final class ImageListViewModelTests: XCTestCase {
    var viewModel = ImageListViewModel()
    var imageRecord = [Photos(
        url: "https://api.slingacademy.com/public/sample-photos/9.jpeg",
        title: "yard",
        id: 2,
        isLike: true
    )]
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testGetImageApiTests() {
        let expectation = self.expectation(description: "GetImageRecords")
        viewModel.getImageDataApiCalling(isSuccess: { isSuccess in
            if isSuccess {
                XCTAssertNotNil(self.viewModel.arrImageResponseModel)
                expectation.fulfill()
            }
        })
        waitForExpectations(timeout: 10) { (error) in
            XCTAssertNil(error)
        }
        tearDown()
    }
    func testSaveAllDataIntoDB() {
        viewModel.saveAllDataIntoDB(
            records: imageRecord
        )
    }
    func testGetDataFromDB() {
        viewModel.getDataFromDB {
            XCTAssertNotNil(self.viewModel.arrImageResponseModel)
        }
    }
    func testGetLikedImagesRecord() {
        viewModel.arrImageResponseModel = imageRecord
        var data = viewModel.getLikedImagesRecord()
        XCTAssertNotNil(data)
    }
}
