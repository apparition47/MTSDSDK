//
//  GitHubClient.swift
//  MTSDSDK
//
//  Created by Aaron Lee on 2021/02/03.
//

import Foundation
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

struct GitHubItem: Codable {
    let id: Int
    let description, name: String
    let `private`: Bool
    let language: String?
}

protocol GitClient {
    func searchRepo(platform: String, org: String, completion: @escaping ([Repo]?) -> Void)
}

class GitHubClient: GitClient {
    let repoSearch = "https://api.github.com/search/repositories"
    let session = URLSession(configuration: URLSessionConfiguration.default)
    
    // Serial Dispatch queue; one req at a time
    private var fetchQueue = DispatchQueue(label: "com.onefatgiraffe.mtsdsdk.fetch", qos: .userInitiated)
    
    func searchRepo(platform: String, org: String, completion: @escaping ([Repo]?) -> Void) {
        fetchQueue.async {
            let request = RestRequest(
                session: self.session,
                method: "GET",
                url: "https://api.github.com/search/repositories?q=\(platform)+org:\(org)"
            )
            request.responseObject { (res: RestResponse<GitHubRootResponse<[GitHubItem]>>?, err) in
                guard let result = res?.result, err == nil else {
                    completion(nil)
                    return
                }
                let repos = result.items.map {
                    Repo(name: $0.name, description: $0.description, isPrivate: $0.private, devLanguage: $0.language)
                }
                completion(repos)
            }
        }
    }
}
