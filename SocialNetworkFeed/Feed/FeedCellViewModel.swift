//
//  FeedViewModel.swift
//  SocialNetworkFeed
//
//  Created by Danila Umnov on 05.03.2025.
//

protocol FeedCellViewModelProtocol {
    var title: String { get }
    var description: String { get }
    var userId: Int { get }
}

final class FeedCellViewModel: FeedCellViewModelProtocol {
    let title: String
    let description: String
    let userId: Int
    
    init(post: Post) {
        self.title = post.title ?? "Default title"
        self.description = post.body ?? "Default description"
        self.userId = Int(post.userId)
    }
}
