//
//  PostWebService.swift
//  Aqua Guard
//
//  Created by Youssef Farhat on 4/12/2023.
//

import Foundation

final class PostWebService{
    
        
    static func createPost(token: String, description: String, imageData: Data) async throws -> Bool {
        let boundary = "Boundary-\(UUID().uuidString)"
        var request = URLRequest(url: URL(string: "https://aquaguard-tux1.onrender.com/posts/")!)
        request.httpMethod = "POST"
        request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        request.addValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        
        var body = Data()
        
        // Description part
        body.append("--\(boundary)\r\n")
        body.append("Content-Disposition: form-data; name=\"description\"\r\n\r\n")
        body.append("\(description)\r\n")
        
        // Image part
        body.append("--\(boundary)\r\n")
        body.append("Content-Disposition: form-data; name=\"image\"; filename=\"image.jpg\"\r\n")
        body.append("Content-Type: image/jpeg\r\n\r\n")
        body.append(imageData)
        body.append("\r\n")
        
        // End boundary
        body.append("--\(boundary)--\r\n")
        
        request.httpBody = body
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse,
              httpResponse.statusCode == 201 else {
            // Handle server errors here
            throw URLError(.badServerResponse)
        }
        // Decode response if needed or just return true to indicate success
        return true
    }
    
    
    static func updatePost(postId: String,token: String, description: String) async throws -> Bool {
        
        let boundary = "Boundary-\(UUID().uuidString)"
        var request = URLRequest(url: URL(string: "https://aquaguard-tux1.onrender.com/posts/\(postId)")!)
        request.httpMethod = "PUT"
        request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        request.addValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        
        var body = Data()
        
        // Description part
        body.append("--\(boundary)\r\n")
        body.append("Content-Disposition: form-data; name=\"description\"\r\n\r\n")
        body.append("\(description)\r\n")
        
        
        // End boundary
        body.append("--\(boundary)--\r\n")
        
        request.httpBody = body
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse,
              httpResponse.statusCode == 201 else {
            // Handle server errors here
            return true
        }
        // Decode response if needed or just return true to indicate success
        return true
    }
    
    static func getPostsData(token: String) async throws -> [PostModel] {
        let urlString = "https://aquaguard-tux1.onrender.com/posts/"
        guard let url = URL(string: urlString) else {
            throw PostErrorHandler.invalidURL
        }
        
        var request = URLRequest(url: url)
        request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
            throw PostErrorHandler.invalidResponse
        }
        
        do {
            let decoder = JSONDecoder()
            return try decoder.decode([PostModel].self, from: data)
        } catch {
            throw PostErrorHandler.invalidData
        }
    }
    
    static func getMyPostsData(token: String) async throws -> [PostModel] {
        let urlString = "https://aquaguard-tux1.onrender.com/posts/postByCurrentUser"
        guard let url = URL(string: urlString) else {
            throw PostErrorHandler.invalidURL
        }
        
        var request = URLRequest(url: url)
        request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
            throw PostErrorHandler.invalidResponse
        }
        
        do {
            let decoder = JSONDecoder()
            return try decoder.decode([PostModel].self, from: data)
        } catch {
            throw PostErrorHandler.invalidData
        }
    }
    
    static func addComment(postId: String, comment: String, token: String) async throws -> Comment {
        let urlString = "https://aquaguard-tux1.onrender.com/posts/\(postId)/comments"
        guard let url = URL(string: urlString) else {
            throw PostErrorHandler.invalidURL
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try JSONEncoder().encode(["comment": comment])
        
        let (data, response) = try await URLSession.shared.data(for: request)
        guard let httpResponse = response as? HTTPURLResponse else {
            throw PostErrorHandler.invalidResponse
        }
        
        switch httpResponse.statusCode {
        case 201:
            // Decode the JSON response into a Comment object
            return try JSONDecoder().decode(Comment.self, from: data)
            
        case 400:
            // If the server returns a 400 status, throw an appropriate error
            throw PostErrorHandler.inappropriateLanguage(data)
        default:
            // Handle other status codes as general errors
            throw PostErrorHandler.invalidResponse
        }
    }
    
    static func deleteComment(commentId: String, token: String) async throws {
        let urlString = "https://aquaguard-tux1.onrender.com/comments/\(commentId)"
        guard let url = URL(string: urlString) else {
            throw PostErrorHandler.invalidURL
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "DELETE"
        request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
        let (data, response) = try await URLSession.shared.data(for: request)
        guard let httpResponse = response as? HTTPURLResponse else {
            throw PostErrorHandler.invalidResponse
        }
        
        switch httpResponse.statusCode {
        case 200:
            print("Comment deleted successfully")
        default:
            // Handle other status codes appropriately
            throw PostErrorHandler.invalidResponse
        }
    }
    
    static func updateComment(commentId: String, newComment: String, token: String) async throws {
        let urlString = "https://aquaguard-tux1.onrender.com/comments/\(commentId)"
        guard let url = URL(string: urlString) else {
            throw PostErrorHandler.invalidURL
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "PUT" // Use PUT method for update
        request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        // Encode the new comment text into JSON
        let body = ["comment": newComment]
        request.httpBody = try JSONEncoder().encode(body)
        
        // Perform the network task
        let (data, response) = try await URLSession.shared.data(for: request)
        guard let httpResponse = response as? HTTPURLResponse else {
            throw PostErrorHandler.invalidResponse
        }
        
        // Check for success status code and handle it
        switch httpResponse.statusCode {
        case 200:
            print("Comment updated successfully")
        case 400:
            // If the server returns a 400 status, throw an appropriate error
            throw PostErrorHandler.inappropriateLanguage(data)
        default:
            // Handle other status codes as general errors
            throw PostErrorHandler.invalidResponse
        }
    }
    
    static func addLike(to postId: String, withToken token: String) async throws {
        let likeURL = "https://aquaguard-tux1.onrender.com/posts/like/\(postId)"
        guard let url = URL(string: likeURL) else {
            throw PostErrorHandler.invalidURL
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
        let (_, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse,
              httpResponse.statusCode == 201 else {
            throw PostErrorHandler.invalidResponse
        }
        
        // Handle the successful response here if needed
    }
    static func dislikePost(with postId: String, andToken token: String) async throws {
        let dislikeURL = "https://aquaguard-tux1.onrender.com/posts/dislike/\(postId)"
        guard let url = URL(string: dislikeURL) else {
            throw PostErrorHandler.invalidURL
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
        let (_, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse,
              httpResponse.statusCode == 200 else {
            throw PostErrorHandler.invalidResponse
        }
        
        // Handle the successful response here if needed
    }
    
    static func isPostLiked(by postId: String, withToken token: String) async throws -> Bool {
        let checkLikeURL = "https://aquaguard-tux1.onrender.com/posts/isLiked/\(postId)"
        guard let url = URL(string: checkLikeURL) else {
            throw PostErrorHandler.invalidURL
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse,
              httpResponse.statusCode == 200 else {
            throw PostErrorHandler.invalidResponse
        }
        
        return try JSONDecoder().decode(Bool.self, from: data)
    }
    static func deletePost(postId: String, token: String) async throws {
        let urlString = "https://aquaguard-tux1.onrender.com/posts/\(postId)"
        guard let url = URL(string: urlString) else {
            throw PostErrorHandler.invalidURL
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "DELETE"
        request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw PostErrorHandler.invalidResponse
        }
        
        switch httpResponse.statusCode {
        case 200:
            // Successfully deleted the post
            break
        default:
            // Handle other status codes as needed
            throw PostErrorHandler.postNotFound
        }
    }
    
    static func fetchAIDescription(for prompt: String, withToken token: String) async throws -> String {
        let encodedPrompt = prompt.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        let descriptionURL = "https://aquaguard-tux1.onrender.com/posts/generateDescriptionWithChat/\(encodedPrompt)"
        guard let url = URL(string: descriptionURL) else {
            throw PostErrorHandler.invalidURL
        }

        var request = URLRequest(url: url)
        request.httpMethod = "GET" // Changed to GET
        request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")

        let (data, response) = try await URLSession.shared.data(for: request)

        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            throw PostErrorHandler.invalidResponse
        }

        // Decode the JSON response to get the description
        let description = try JSONDecoder().decode(AIDescriptionResponse.self, from: data).description

        return description
    }

    
}
struct AIDescriptionResponse: Decodable {
    let description: String
}


