//
//  RestError.swift
//  MTSDSDK
//
//  Created by Aaron Lee on 2021/02/03.
//

import Foundation

enum RestError {
    case noResponse
    case noData
    case serialization(values: String)
    case deserialization(values: String)
    case badURL
    case sslCertificateUntrusted
    case http(statusCode: Int?, message: String?, metadata: [String: Any]?)
    case other(message: String?, metadata: [String: Any]?)
}

extension RestError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .noResponse:
            return "No response was received from the server"
        case .noData:
            return "No data was returned by the server"
        case .serialization(let values):
            return "Failed to serialize " + values
        case .deserialization(let values):
            return "Failed to deserialize " + values
        case .badURL:
            return "Malformed URL"
        case .sslCertificateUntrusted:
            return "The connection failed because the SSL certificate is not valid or is self-signed."
        case .http(_, let message, _):
            return message
        case .other(let message, _):
            return message
        }
    }
}
