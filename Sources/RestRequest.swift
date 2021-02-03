//
//  Network.swift
//  MTSDSDK
//
//  Created by Aaron Lee on 2021/02/03.
//

import Foundation

struct RestRequest {
    private let session: URLSession
    let method: String
    let url: String
    
    init(session: URLSession, method: String, url: String) {
        self.session = session
        self.method = method
        self.url = url
    }
    
    private var urlRequest: URLRequest? {
        guard let urlWithQuery = URL(string: url) else { return nil }
        var request = URLRequest(url: urlWithQuery)
        request.httpMethod = method
        return request
    }
}

// MARK: - Response Functions

extension RestRequest {
    func execute(completion: @escaping (Data?, HTTPURLResponse?, RestError?) -> Void) {
        let request = self
        guard let urlRequest = request.urlRequest else {
            completion(nil, nil, RestError.badURL)
            return
        }

        let task = self.session.dataTask(with: urlRequest) { (data, response, error) in
            // handle SSL untrusted errors prior to any HTTP handling
            // as these errors are NSErrors where repsonse is nil
            if let error = error as NSError? {
                if error.code == NSURLErrorServerCertificateUntrusted {
                    completion(nil, nil, RestError.sslCertificateUntrusted)
                    return
                }
            }

            guard let response = response as? HTTPURLResponse else {
                let error = RestError.noResponse
                completion(data, nil, error)
                return
            }

            guard error == nil else {
                let restError = RestError.http(statusCode: response.statusCode, message: "\(String(describing: error))", metadata: nil)
                completion(data, response, restError)
                return
            }

            guard (200..<300).contains(response.statusCode) else {
                if let data = data {
                    completion(data, response, nil)
                } else {
                    let genericMessage = HTTPURLResponse.localizedString(forStatusCode: response.statusCode)
                    let genericError = RestError.http(statusCode: response.statusCode, message: genericMessage, metadata: nil)
                    completion(data, response, genericError)
                }
                return
            }

            completion(data, response, nil)
        }

        task.resume()
    }
    
    public func responseObject<T: Decodable>(completion: @escaping (RestResponse<T>?, RestError?) -> Void) {
        execute { data, response, error in
            guard let response = response else {
                completion(nil, error ?? RestError.noResponse)
                return
            }
        
            var restResponse = RestResponse<T>(response: response)
            
            if let error = error {
                completion(restResponse, error)
                return
            }
            
            guard let data = data else {
                completion(restResponse, RestError.noData)
                return
            }
            
            let parsed: (T?, RestError?) = parse(data)
            restResponse.result = parsed.0
            return completion(restResponse, parsed.1)
        }
    }
    
    func parse<T: Decodable>(_ data: Data) -> (T?, RestError?) {
        do {
            let result = try JSONDecoder().decode(T.self, from: data)
            #if DEBUG
            print(result)
            #endif
            return (result, nil)
        } catch DecodingError.dataCorrupted(let context) {
            let keyPath = context.codingPath.map{$0.stringValue}.joined(separator: ".")
            let values = "response JSON: data Corrupted at \(keyPath): " + context.debugDescription
            return (nil, RestError.deserialization(values: values))
        } catch DecodingError.keyNotFound(let key, _) {
            let values = "response JSON: key not found for \(key.stringValue)"
            return (nil, RestError.deserialization(values: values))
        } catch DecodingError.typeMismatch(_, let context) {
            let keyPath = context.codingPath.map{$0.stringValue}.joined(separator: ".")
            let values = "response JSON: type mismatch for \(keyPath): " + context.debugDescription
            return (nil, RestError.deserialization(values: values))
        } catch DecodingError.valueNotFound(_, let context) {
            let keyPath = context.codingPath.map{$0.stringValue}.joined(separator: ".")
            let values = "response JSON: value not found for \(keyPath): " + context.debugDescription
            return (nil, RestError.deserialization(values: values))
        } catch {
            return (nil, RestError.deserialization(values: "response JSON: " + error.localizedDescription))
        }
    }
}
