//
//  RestResponse.swift
//  MTSDSDK
//
//  Created by Aaron Lee on 2021/02/03.
//

import Foundation
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

struct GitHubRootResponse<T: Decodable>: Decodable {
    let totalCount: Int
    let incompleteResults: Bool
    let items: T

    enum CodingKeys: String, CodingKey {
        case totalCount = "total_count"
        case incompleteResults = "incomplete_results"
        case items
    }
}

struct RestResponse<T> {
    public var statusCode: Int
    public var headers: [String: String]
    public var result: T?

    public init(statusCode: Int, headers: [String: String] = [:]) {
        self.statusCode = statusCode
        self.headers = headers
    }

    init(response: HTTPURLResponse) {
        var headers: [String: String] = [:]
        for (key, value) in response.allHeaderFields {
            if let key = key as? String, let value = value as? String {
                headers[key] = value
            }
        }
        self.init(statusCode: response.statusCode, headers: headers)
    }
}
