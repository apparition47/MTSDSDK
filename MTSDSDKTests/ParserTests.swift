//
//  ParserTests.swift
//  MTSDSDKTests
//
//  Created by Aaron Lee on 2021/02/03.
//

import XCTest
@testable import MTSDSDK

class ParserTests: XCTestCase {
    
    var client: RestRequest!
    
    override func setUp() {
        client = RestRequest(session: .shared, method: "GET", url: "")
    }
    
    func testEmptyData() {
        let parser: (GitHubRootResponse<[GitHubItem]>?, RestError?) = client.parse(Data())
        XCTAssertNil(parser.0)
    }
    
    func testSuccessParse() {
        let stub = getStub("success")
        let res: (GitHubRootResponse<[GitHubItem]>?, RestError?) = client.parse(stub)
        let root = res.0
        XCTAssertNotNil(root)
        XCTAssertTrue(type(of: root!) == GitHubRootResponse<[GitHubItem]>.self)
        XCTAssertTrue(root!.totalCount > 0)
        XCTAssertTrue(type(of: root!.items) == [GitHubItem].self)
        XCTAssertFalse(root!.items.isEmpty)
    }
    
    func testFailureParse() {
        let stub = getStub("failure")
        let res: (GitHubRootResponse<[GitHubItem]>?, RestError?) = client.parse(stub)
        let err = res.1
        XCTAssertNotNil(err)
    }
    
    // MARK: - Helpers
    
    private func getStub<T: Decodable>(_ jsonFile: String, as: T.Type) -> T {
        let data = getStub(jsonFile)
        let decoder = JSONDecoder()
        return try! decoder.decode(T.self, from: data)
    }
    
    private func getStub(_ jsonFile: String) -> Data {
        let url = Bundle(for: type(of: self)).path(forResource: jsonFile, ofType: "json")!
        return try! Data(contentsOf: URL(fileURLWithPath: url))
    }
}
