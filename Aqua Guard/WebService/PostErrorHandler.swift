//
//  PostErrorHandler.swift
//  Aqua Guard
//
//  Created by Youssef Farhat on 4/12/2023.
//

import Foundation

enum PostErrorHandler: LocalizedError {
    case invalidURL
       case invalidResponse
       case invalidData
       case inappropriateLanguage(Data)
       
       var errorDescription: String? {
           switch self {
           case .invalidURL:
               return "Invalid URL"
               
           case .invalidResponse:
               return "Invalid Response"
               
           case .invalidData:
               return "Invalid data"
            
        
               
           case .inappropriateLanguage(let data):
                      return extractErrorMessage(from: data)
                  }
       }
    private func extractErrorMessage(from data: Data) -> String {
        if let serverError = try? JSONDecoder().decode(ServerErrorMessage.self, from: data),
           let firstError = serverError.errors.first {
            return firstError.msg
        } else {
            return "An error occurred"
        }
    }

    
}
// To handel Bad word error
struct ServerErrorMessage: Decodable {
    let errors: [ErrorDetail]
}

struct ErrorDetail: Decodable {
    let msg: String
}
