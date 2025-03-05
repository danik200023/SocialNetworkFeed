//
//  NetworkManager.swift
//  SocialNetworkFeed
//
//  Created by Danila Umnov on 05.03.2025.
//

import Foundation
import Alamofire

final class NetworkManager {
    static let shared = NetworkManager()
    
    private init() {}
    
    func get<T: Decodable>(
        _ type: T.Type,
        from url: URLConvertible,
        completion: @escaping (Result<T, AFError>) -> Void
    ) {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        
        AF.request(url)
            .validate()
            .responseDecodable(of: type, decoder: decoder) { response in
                completion(response.result)
            }
    }
    
    func loadImage(from url: URLConvertible, completion: @escaping (Result<Data?, AFError>) -> Void) {
        AF.request(url)
            .validate().response{ response in
                completion(response.result)
            }
    }
}
