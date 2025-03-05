//
//  FeedViewModel.swift
//  SocialNetworkFeed
//
//  Created by Danila Umnov on 05.03.2025.
//

import Foundation

protocol FeedViewModelProtocol {
    func numberOfRowsInSection(_ section: Int) -> Int
    func getPostsFromCache(completion: @escaping (Int) -> Void)
    func getPostsFromWeb(completion: @escaping (Int) -> Void)
    func getFeedCellViewModel(at indexPath: IndexPath) -> FeedCellViewModelProtocol
}

final class FeedViewModel: FeedViewModelProtocol {
    private let storageManager = StorageManager.shared
    private var posts: [Post] = []
    
    private func filterNewPosts(_ postsDTO: [PostDTO], _ existingPosts: [Post]) -> [Post] {
        let existingIds = Set(existingPosts.map { Int($0.id) })
        let filteredPostsDTO = postsDTO.filter { !existingIds.contains(Int($0.id)) }
        var newPosts: [Post] = []
        filteredPostsDTO.forEach { storageManager.createPost(withId: $0.id, userId: $0.userId, title: $0.title, body: $0.body) { post in
            newPosts.append(post)
        } }
        
        return newPosts
    }
    
    func numberOfRowsInSection(_ section: Int) -> Int {
        posts.count
    }
    
    func getPostsFromCache(completion: @escaping (Int) -> Void) {
        storageManager.fetchData { [unowned self] result in
            switch result {
            case .success(let posts):
                self.posts = posts
                completion(posts.count)
            case .failure(let error):
                print(error)
                completion(0)
            }
        }
    }
    
    func getPostsFromWeb(completion: @escaping (Int) -> Void) {
        NetworkManager.shared.get(
            [PostDTO].self,
            from: "https://jsonplaceholder.typicode.com/posts"
        ) { [unowned self] result in
            switch result {
            case .success(let postsDTO):
                let sortedPostsDTO = postsDTO.sorted { $0.id > $1.id }
                
                if posts.isEmpty {
                    sortedPostsDTO.forEach { storageManager.createPost(withId: $0.id, userId: $0.userId, title: $0.title, body: $0.body) { post in
                        posts.append(post)
                    } }
                    completion(sortedPostsDTO.count)
                } else {
                    let newPosts = filterNewPosts(sortedPostsDTO, posts)
                    if !newPosts.isEmpty {
                        posts.insert(contentsOf: newPosts, at: 0)
                    }
                    completion(newPosts.count)
                }
            case .failure(let error):
                print(error)
                completion(0)
            }
        }
    }
    
    func getFeedCellViewModel(at indexPath: IndexPath) -> FeedCellViewModelProtocol {
        FeedCellViewModel(post: posts[indexPath.row])
    }
}
