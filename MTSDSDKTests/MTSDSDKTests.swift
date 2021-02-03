//
//  MTSDSDKTests.swift
//  MTSDSDKTests
//
//  Created by Aaron Lee on 2021/02/03.
//

import XCTest
@testable import MTSDSDK

class MTSDSDKTests: XCTestCase {

    var repo: Repository!
    
    override func setUp() {
        repo = GitHubRepository()
    }
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testIntegration() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        let parseExpectation = expectation(description: "integration")
        var fetchedRes: [Repo]?
        repo.list(for: .Android, by: "rakutentech") { res in
            fetchedRes = res
            parseExpectation.fulfill()
        }
        
        waitForExpectations(timeout: 10.0, handler: nil)
        XCTAssertNotNil(fetchedRes)
        XCTAssert(type(of: fetchedRes!) == [Repo].self)
        XCTAssertTrue(fetchedRes!.count > 0)
    }

}
