//
//  ParticipationWebService.swift
//  Aqua Guard
//
//  Created by Malek Labidi on 5/12/2023.
//

import Foundation
final class ParticipationWebService {
    static let shared = ParticipationWebService()
    private let baseURL = "https://aquaguard-tux1.onrender.com"
    
    func addParticipation(eventId: String, token: String) {
        // Define the API endpoint URL with the eventId as a query parameter
        let apiUrlString = "\(baseURL)/participations/participate/\(eventId)"
        
        // Create the URL
        guard let url = URL(string: apiUrlString) else {
            return
        }
        
        // Create the request
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization") // Add the token to the request header

        // Perform the request
        URLSession.shared.dataTask(with: request) { data, response, error in
            // Check for errors
            if let error = error {
                print("Error adding participation: \(error)")
                return
            }
           
        }.resume()
    }
    
    
    
    func deleteParticipation(eventId: String, token: String) {
        // Define the API endpoint URL with the eventId as a query parameter
        let apiUrlString = "\(baseURL)/participations/participate/\(eventId)"
        
        // Create the URL
        guard let url = URL(string: apiUrlString) else {
            return
        }
        
        // Create the request
        var request = URLRequest(url: url)
        request.httpMethod = "DELETE"
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization") // Add the token to the request header

        // Perform the request
        URLSession.shared.dataTask(with: request) { data, response, error in
            // Check for errors
            if let error = error {
                print("Error deleting participation: \(error)")
                return
            }
           
        }.resume()
    }
    
    func isParticipated(eventId: String, token: String) async throws -> Bool {
        // Define the API endpoint URL with the eventId as a query parameter
        let apiUrlString = "\(baseURL)/participations/participate/\(eventId)"
        
        // Create the URL
        guard let url = URL(string: apiUrlString) else {
            throw URLError(.badURL)
        }
        
        // Create the request
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization") // Add the token to the request header

        // Perform the request
        let (data, response) = try await URLSession.shared.data(for: request)
        
     

        guard let httpResponse = response as? HTTPURLResponse,
              httpResponse.statusCode == 200 else {
            throw EventErrorHandler.invalidResponse
        }

        return try JSONDecoder().decode(Bool.self, from: data)
    }

    
     func getAllByUser(token: String) async throws -> [Participation] {
           let apiUrlString = "\(baseURL)/participations/user"
           guard let url = URL(string: apiUrlString) else {
               throw NSError(domain: "Invalid URL", code: 0, userInfo: nil)
           }
         
           var request = URLRequest(url: url)
           request.httpMethod = "GET"
           request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")

           do {
               let (data, _) = try await URLSession.shared.data(for: request)
               print(String(data: data, encoding: .utf8) ?? "Data not in UTF-8")

               print("test")
               let decodedData = try JSONDecoder().decode([Participation].self, from: data)
               print("dataaaa")
               print(decodedData)
               
               return decodedData
           } catch {
               throw error
           }
       }

    

    
}
