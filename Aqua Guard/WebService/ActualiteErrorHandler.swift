//
//  ActualiteErrorHandler.swift
//  Aqua Guard
//
//  Created by ademseddik on 6/12/2023.
//

import Foundation


enum ActualiteErrorHandler: LocalizedError {
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
