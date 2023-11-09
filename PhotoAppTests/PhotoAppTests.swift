//
//  PhotoAppTests.swift
//  PhotoAppTests
//
//  Created by Wass on 06/11/2023.
//

import XCTest
@testable import PhotoApp

final class PhotoAppTests: XCTestCase {
    
    let apiHelper: APIHelper = MockUnsplashAPIHelper()

    func testPerformRequest() {

        //When
        let expectation = XCTestExpectation(description: "Wait for queu change")
        apiHelper.performRequest("1") { success , photos in
            //Then
            XCTAssertTrue(success)
            XCTAssertNotNil(photos)
            XCTAssertEqual(photos?.count, 1)
            expectation.fulfill()
            
            
        }
        wait(for: [expectation], timeout: 0.01)
        
    }
    
    func testFetchUserImages() {

        //When
        let expectation = XCTestExpectation(description: "Wait for queu change")
        apiHelper.fetchUserImages("Neom") { success , photos in
            //Then
            XCTAssertTrue(success)
            XCTAssertNotNil(photos)
            XCTAssertEqual(photos?.count, 2)
            expectation.fulfill()
            
            
        }
        wait(for: [expectation], timeout: 0.01)
        
    }
    
    
    func testFetchImagesByQuery() {

        //When
        let expectation = XCTestExpectation(description: "Wait for queu change")
        apiHelper.fetchImagesByQuery("3","Water") { success , photos in
            //Then
            XCTAssertTrue(success)
            XCTAssertNotNil(photos)
            XCTAssertEqual(photos?.count, 3)
            expectation.fulfill()
            
            
        }
        wait(for: [expectation], timeout: 0.01)
        
    }

}
