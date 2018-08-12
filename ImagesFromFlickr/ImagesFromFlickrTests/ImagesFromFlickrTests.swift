//
//  ImagesFromFlickrTests.swift
//  ImagesFromFlickrTests
//
//  Created by Anita Agrawal on 07/08/18.
//  Copyright © 2018 Anita Agrawal. All rights reserved.
//

import XCTest
@testable import ImagesFromFlickr

class ImagesFromFlickrTests: XCTestCase {

    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
        ConnectionManager.manager = .mock
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        ConnectionManager.manager = .live
        super.tearDown()
    }
    
    func testSuccessfulResponse() {
        // Setup our objects
        URLSessionMock.responseCode = .success
        var responseObj: [String: Any]?
        let expect = expectation(description: "Flickr Search")
        
        let task = ConnectionManager.makeHTTPRequest(url: APIEndPoints.Search, queryParameters: [APIConstants.page: "\(1)", APIConstants.per_page: "\(5)","text": "kitten"], bodyParameters: [:], completionHandler: { (response) in
            print(response)
            switch response {
            case .success(let res):
                responseObj = res
            case .failure(_):
                responseObj = nil
            }
            expect.fulfill()
        })
        task?.resume()
        waitForExpectations(timeout: 5.0, handler: nil)
        XCTAssert((responseObj != nil))
    }
    func testClientErrorResponse() {
        // Setup our objects
        URLSessionMock.responseCode = .authenticationFail
        var responseObj: ErrorHandling?
        let expect = expectation(description: "Flickr Search")
        
        let task = ConnectionManager.makeHTTPRequest(url: APIEndPoints.Search, queryParameters: [APIConstants.page: "\(1)", APIConstants.per_page: "\(5)","text": "kitten"], bodyParameters: [:], completionHandler: { (response) in
            print(response)
            switch response {
            case .success(_):
                responseObj = nil
            case .failure(let error):
                responseObj = error
            }
            expect.fulfill()
        })
        task?.resume()
        waitForExpectations(timeout: 5.0, handler: nil)
        XCTAssert((responseObj != nil))
        XCTAssertTrue(responseObj == ErrorHandling.clientError)
    }
    func testServerErrorResponse() {
        // Setup our objects
        URLSessionMock.responseCode = .internalServerError
        var responseObj: ErrorHandling?
        let expect = expectation(description: "Flickr Search")
        
        let task = ConnectionManager.makeHTTPRequest(url: APIEndPoints.Search, queryParameters: [APIConstants.page: "\(1)", APIConstants.per_page: "\(5)","text": "kitten"], bodyParameters: [:], completionHandler: { (response) in
            print(response)
            switch response {
            case .success(_):
                responseObj = nil
            case .failure(let error):
                responseObj = error
            }
            expect.fulfill()
        })
        task?.resume()
        waitForExpectations(timeout: 5.0, handler: nil)
        XCTAssert((responseObj != nil))
        XCTAssertTrue(responseObj == ErrorHandling.internalServerError)
    }
}
