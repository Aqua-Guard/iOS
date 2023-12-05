//
//  EventService.swift
//  Aqua Guard
//
//  Created by Malek Labidi on 5/12/2023.
//

import Foundation
class EventWebService {
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
 }

