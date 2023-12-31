//
//  ReclamationErrorHandler.swift
//  Aqua Guard
//
//  Created by Mac Mini 5 on 14/12/2023.
//

import Foundation


enum ReclamationErrorHandler: LocalizedError {
    case invalidURL
       case invalidResponse
       case invalidData
       case inappropriateLanguage(Data)
       
       var errorDescription: String? {
           switch self {
           case .invalidURL:
               return "Invalid reclamation URL"
               
           case .invalidResponse:
               return "Invalid reclamation Response"
               
           case .invalidData:
               return "Invalid reclamation data"
            
        
               
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
