//
//  EventService.swift
//  Aqua Guard
//
//  Created by Malek Labidi on 5/12/2023.
//

import Foundation




extension Data {
    mutating func append(_ string: String) {
        if let data = string.data(using: .utf8) {
            append(data)
        }
    }
}
final class EventWebService {
    static let shared = EventWebService()
    private let baseURL = "http://127.0.0.1:9090"

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
                    throw PostErrorHandler.invalidResponse
                }

                switch httpResponse.statusCode {
                case 200:
                    print("Event deleted successfully")
                default:
                    // Handle other status codes appropriately
                    throw PostErrorHandler.invalidResponse
                }
             }
    
    
    func addEvent(token: String,event: EventRequest, image: Data)async throws -> Bool {
        let urlString = "\(baseURL)/events"
            guard let url = URL(string: urlString)
        else {
                print("Invalid URL")
                return false
            }

            var request = URLRequest(url: url)
            request.httpMethod = "POST"

            let boundary = "Boundary-\(UUID().uuidString)"
            request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
            request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")


            var body = Data()

            // Append image data
        body.append("--\(boundary)\r\n")
        body.append("Content-Disposition: form-data; name=\"image\"; filename=\"image.jpg\"\r\n")
        body.append("Content-Type: image/jpeg\r\n\r\n")
        body.append(image)
        body.append("\r\n")

            // Append other fields
        body.append(convertFormField(named: "name", value: event.eventName, boundary: boundary))
        body.append(convertDateField(named: "DateDebut", date: event.dateDebut, boundary: boundary))
        body.append(convertDateField(named: "DateFin", date: event.dateFin, boundary: boundary))
        body.append(convertFormField(named: "Description", value: event.description, boundary: boundary))
        body.append(convertFormField(named: "lieu", value: event.lieu, boundary: boundary))


            body.append("--\(boundary)--".data(using: .utf8)!)

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
    
    
    func updateEvent(token: String, eventId: String, event: EventRequest, image: Data?)async throws -> Bool {
        guard let url = URL(string: "\(baseURL)/events/\(eventId)") else {
            print("Invalid URL")
           
            return false
        }

        var request = URLRequest(url: url)
        request.httpMethod = "PUT"

        let boundary = "Boundary-\(UUID().uuidString)"
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")

        var body = Data()

        // Append image data if available
        if let image = image {
            body.append("--\(boundary)\r\n")
            body.append("Content-Disposition: form-data; name=\"image\"; filename=\"image.jpg\"\r\n")
            body.append("Content-Type: image/jpeg\r\n\r\n")
            body.append(image)
            body.append("\r\n")
        }

        // Append other fields
        body.append(convertFormField(named: "name", value: event.eventName, boundary: boundary))
        body.append(convertDateField(named: "DateDebut", date: event.dateDebut, boundary: boundary))
        body.append(convertDateField(named: "DateFin", date: event.dateFin, boundary: boundary))
        body.append(convertFormField(named: "Description", value: event.description, boundary: boundary))
        body.append(convertFormField(named: "lieu", value: event.lieu, boundary: boundary))

        body.append("--\(boundary)--".data(using: .utf8)!)

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


    
    
    
    func convertFormField(named name: String, value: String, boundary: String) -> Data {
            var fieldData = Data()
            fieldData.append("--\(boundary)\r\n".data(using: .utf8)!)
            fieldData.append("Content-Disposition: form-data; name=\"\(name)\"\r\n\r\n".data(using: .utf8)!)
            fieldData.append("\(value)\r\n".data(using: .utf8)!)
            return fieldData
        }
    
  

    func convertDateField(named name: String, date: Date, boundary: String) -> Data {
        var body = Data()

        // Append form field header
        body.append("--\(boundary)\r\n")
        body.append("Content-Disposition: form-data; name=\"\(name)\"\r\n\r\n")

        // Convert date to string using a DateFormatter
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss" // Adjust the date format as needed
        let dateString = dateFormatter.string(from: date)

        // Append date string to the body
        body.append("\(dateString)\r\n")

        return body
    }


    
 }

    
