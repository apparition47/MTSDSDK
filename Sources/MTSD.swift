//
//  MTSD.swift
//  MTSDSDK
//
//  Created by Aaron Lee on 2021/02/03.
//

import Foundation

public enum Platform: String {
    case iOS = "ios"
    case Android = "android"
}

public struct Repo {
    let name, description: String
    let isPrivate: Bool
    let devLanguage: String?
}

public protocol Repository {

    /**
     List all repos under an organization by platform..

     - parameter platform: Either iOS or Android.
     - parameter org: GH Organization to lookup.
     - parameter completionHandler: The completion handler to return an array of `Repo`.
     */
    func list(for platform: Platform, by org: String, completion: @escaping ([Repo]?) -> Void)
}

public class GitHubRepository: Repository {

    public init() {}

    public func list(for platform: Platform, by org: String, completion: @escaping ([Repo]?) -> Void) {
        GitHubClient().searchRepo(platform: platform.rawValue, org: org) { res in
            completion(res)
        }
    }
}
