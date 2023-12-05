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
    
    
    func addEvent(token: String,event: Event, image: URL, completion: @escaping (Result<Void, Error>) -> Void) {
        let urlString = "\(baseURL)/events"
            guard let url = URL(string: urlString)
        else {
                print("Invalid URL")
                completion(.failure(URLError(.badURL)))
                return
            }

            var request = URLRequest(url: url)
            request.httpMethod = "POST"

            let boundary = "Boundary-\(UUID().uuidString)"
            request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
            request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")


            var body = Data()

            // Append image data
            body.append(convertFileData(fieldName: "image",
                                        fileName: image.lastPathComponent,
                                        mimeType: "image/jpeg", // Adjust MIME type as needed
                                        fileUrl: image,
                                        boundary: boundary))

            // Append other fields
        body.append(convertFormField(named: "name", value: event.eventName, boundary: boundary))
        body.append(convertDateField(named: "DateDebut", date: event.dateDebut, boundary: boundary))
        body.append(convertDateField(named: "DateFin", date: event.dateFin, boundary: boundary))
        body.append(convertFormField(named: "Description", value: event.description, boundary: boundary))
        body.append(convertFormField(named: "lieu", value: event.lieu, boundary: boundary))


            body.append("--\(boundary)--".data(using: .utf8)!)

            request.httpBody = body

            URLSession.shared.dataTask(with: request) { data, response, error in
                if let error = error {
                    completion(.failure(error))
                    return
                }
                guard let response = response as? HTTPURLResponse, (200...299).contains(response.statusCode) else {
                    completion(.failure(URLError(.badServerResponse)))
                    return
                }
                completion(.success(()))
            }.resume()
        }
    
    func convertFormField(named name: String, value: String, boundary: String) -> Data {
            var fieldData = Data()
            fieldData.append("--\(boundary)\r\n".data(using: .utf8)!)
            fieldData.append("Content-Disposition: form-data; name=\"\(name)\"\r\n\r\n".data(using: .utf8)!)
            fieldData.append("\(value)\r\n".data(using: .utf8)!)
            return fieldData
        }
    
    func convertFileData(fieldName: String, fileName: String, mimeType: String, fileUrl: URL, boundary: String) -> Data {
            var data = Data()

            data.append("--\(boundary)\r\n".data(using: .utf8)!)
            data.append("Content-Disposition: form-data; name=\"\(fieldName)\"; filename=\"\(fileName)\"\r\n".data(using: .utf8)!)
            data.append("Content-Type: \(mimeType)\r\n\r\n".data(using: .utf8)!)
            if let fileData = try? Data(contentsOf: fileUrl) {
                data.append(fileData)
            }
            data.append("\r\n".data(using: .utf8)!)

            return data
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

    
