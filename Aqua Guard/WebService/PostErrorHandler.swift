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
       case custom(error: Error)
       
       var errorDescription: String? {
           switch self {
           case .invalidURL:
               return "Invalid URL"
               
           case .invalidResponse:
               return "Invalid Response"
               
           case .invalidData:
               return "Invalid data"
               
           case .custom(let error):
               return error.localizedDescription
           }
       }
    
}

