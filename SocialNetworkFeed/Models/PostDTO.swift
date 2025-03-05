//
//  PostDTO.swift
//  SocialNetworkFeed
//
//  Created by Danila Umnov on 05.03.2025.
//

struct PostDTO: Decodable {
    let id: Int
    let userId: Int
    let title: String
    let body: String
}
