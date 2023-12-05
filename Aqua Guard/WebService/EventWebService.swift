//
//  EventService.swift
//  Aqua Guard
//
//  Created by Malek Labidi on 5/12/2023.
//

import Foundation
final class EventWebService {
    static let shared = EventWebService()
    private let baseURL = "http://192.168.43.253:9090"

    func fetchEvents(token: String,completion: @escaping ([Event]?) -> Void) {
         let url = URL(string: "\(baseURL)/events")!
        
        var request = URLRequest(url: url)
        request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
        URLSession.shared.dataTask(with: request) { data, response, error in
                guard let data = data, error == nil else {
                    print("Error fetching events:", error?.localizedDescription ?? "Unknown error")
                    completion(nil)
                    return
                }

             do {
                 if let jsonArray = try JSONSerialization.jsonObject(with: data, options: []) as? [[String: Any]] {
                     print("jsonArray-----------")
                     print(jsonArray)
                     let events = jsonArray.compactMap {
                        Event(json: $0) }
                     print("events---------------")
                     print(events)
                     completion(events)
                 } else {
                     completion(nil)
                 }
             } catch let error{
                 print("*****User creation failed with error: \(error)")
                 completion(nil)
             }
         }.resume()
     }
    
    func fetchUserEvents(token: String,completion: @escaping ([Event]?) -> Void) {
         let url = URL(string: "\(baseURL)/events/eventByCurrentUser")!
        
        var request = URLRequest(url: url)
        request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
        URLSession.shared.dataTask(with: request) { data, response, error in
                guard let data = data, error == nil else {
                    print("Error fetching events:", error?.localizedDescription ?? "Unknown error")
                    completion(nil)
                    return
                }

             do {
                 if let jsonArray = try JSONSerialization.jsonObject(with: data, options: []) as? [[String: Any]] {
                     print("jsonArray-----------")
                     print(jsonArray)
                     let events = jsonArray.compactMap {
                        Event(json: $0) }
                     print("events---------------")
                     print(events)
                     completion(events)
                 } else {
                     completion(nil)
                 }
             } catch let error{
                 print("*****User creation failed with error: \(error)")
                 completion(nil)
             }
         }.resume()
     }

            func deleteEvent(eventId: String, token: String) async throws {
                 let urlString = "\(baseURL)/events/\(eventId)"
                 guard let url = URL(string: urlString) else {
                     throw PostErrorHandler.invalidURL
                 }

                 var request = URLRequest(url: url)
                 request.httpMethod = "DELETE"
                 request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")

                 let (data, response) = try await URLSession.shared.data(for: request)
                 guard let httpResponse = response as? HTTPURLResponse else {
                     throw EventErrorHandler.invalidResponse
                 }

                 switch httpResponse.statusCode {
                 case 204:
                     // Successfully deleted the event
                     return

                 case 403:
                     // If the server returns a 403 status, throw an appropriate error
                     throw EventErrorHandler.inappropriateLanguage(data)

                 default:
                     // Handle other status codes as general errors
                     throw EventErrorHandler.invalidResponse
                 }
             }
    
 }

    
