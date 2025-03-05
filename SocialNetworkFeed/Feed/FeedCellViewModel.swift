//
//  FeedViewModel.swift
//  SocialNetworkFeed
//
//  Created by Danila Umnov on 05.03.2025.
//

import Foundation

protocol FeedCellViewModelProtocol {
    var title: String { get }
    var description: String { get }
    var username: String { get }
    var avatarUrl: URL { get }
    var userId: Int { get }
    
    func loadImage(completion: @escaping (Data) -> Void)
}

final class FeedCellViewModel: FeedCellViewModelProtocol {
    let title: String
    let description: String
    let username: String
    let avatarUrl: URL
    let userId: Int
    
    init(post: Post) {
        title = post.title ?? "Default title"
        description = post.body ?? "Default description"
        username = "User \(post.userId)"
        avatarUrl = URL(string: "https://picsum.photos/id/\(post.userId)/200")!
        userId = Int(post.userId)
    }
    
    func loadImage(completion: @escaping (Data) -> Void) {
        NetworkManager.shared.loadImage(from: avatarUrl) { result in
            switch result {
            case .success(let data):
                completion(data ?? Data())
            case .failure(let error):
                print(error)
            }
        }
    }
}

