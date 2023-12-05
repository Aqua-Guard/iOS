//
//  PostWebService.swift
//  Aqua Guard
//
//  Created by Youssef Farhat on 4/12/2023.
//

import Foundation

final class PostWebService{
    static func getPostsData() async throws -> [PostModel] {
        let urlString = "http://127.0.0.1:9090/posts/"
        guard let url = URL(string: urlString) else {
                throw PostErrorHandler.invalidURL
            }
            
            let (data, response) = try await URLSession.shared.data(from: url)
            
            guard let response = response as? HTTPURLResponse,
                    response.statusCode == 200 else {
                throw PostErrorHandler.invalidResponse
            }
            
            do {
                let decoder = JSONDecoder()
                return try decoder.decode([PostModel].self, from: data)
            } catch {
                throw PostErrorHandler.invalidData
            }
        }
}
