//
//  ActualiteWebService.swift
//  Aqua Guard
//
//  Created by ademseddik on 6/12/2023.
//

import Foundation

final class ActualiteWebService{
    static let shared = ActualiteWebService()
    private let baseURL = "http://192.168.178.190:9090"
    
    
    
    func fetchactualite(completion: @escaping ([Actualite]?) -> Void) {
        let url = URL(string: "\(baseURL)/act")!
        
        var request = URLRequest(url: url)
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                print("Error fetching actualite:", error?.localizedDescription ?? "Unknown error")
                completion(nil)
                return
            }
            
            do {
                if let jsonArray = try JSONSerialization.jsonObject(with: data, options: []) as? [[String: Any]] {
                    print("jsonArray-----------")
                    print(jsonArray)
                    let actualite = jsonArray.compactMap {
                        Actualite(json: $0) }
                    print("actualite---------------")
                    print(actualite)
                    completion(actualite)
                } else {
                    completion(nil)
                }
            } catch let error{
                print("*****User creation failed with error: \(error)")
                completion(nil)
            }
        }.resume()
    }
    
    
    
    
    
    func searchActualites(about: String, completion: @escaping ([Actualite]?) -> Void) {
        let urlString = "http://192.168.178.190:9090/act/search"
        guard let url = URL(string: urlString) else {
            print("Invalid URL")
            completion(nil)
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")

        do {
            request.httpBody = try JSONEncoder().encode(["about": about])
        } catch {
            print("Error encoding request body:", error.localizedDescription)
            completion(nil)
            return
        }
/////////////////////
        ///
        ///
        URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                print("Error searching actualites:", error?.localizedDescription ?? "Unknown error")
                completion(nil)
                return
            }

            do {
                if let jsonArray = try JSONSerialization.jsonObject(with: data, options: []) as? [[String: Any]] {
                    print("jsonArray-----------")
                    print(jsonArray)
                    let actualite = jsonArray.compactMap {
                        Actualite(json: $0) }
                    print("actualite---------------")
                    print(actualite)
                    completion(actualite)
                } else {
                    completion(nil)
                }
            } catch {
                print("Error decoding search result:", error.localizedDescription)
                completion(nil)
            }
        }.resume()
    }
    func addOrUpdateAvis(userId: String, actualiteTitle: String, avis: String, completion: @escaping (Bool, Error?) -> Void) {
        let url = URL(string: "http://192.168.178.190:9090/avis/addupdates")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")

        // Create a dictionary representing the request body
        let requestBody: [String: Any] = ["userId": userId,
                                          "actualiteTitle": actualiteTitle,
                                          "avis": avis]

        do {
            // Convert the dictionary to JSON data
            request.httpBody = try JSONSerialization.data(withJSONObject: requestBody)
        } catch {
            print("Error encoding request body:", error.localizedDescription)
            completion(false, error)
            return
        }

        URLSession.shared.dataTask(with: request) { data, response, error in
            guard error == nil else {
                completion(false, error)
                return
            }

            guard let data = data else {
                completion(false, nil)
                return
            }

            do {
                if let jsonObject = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
                    let message = jsonObject["message"] as? String {
                    // Check the response message to determine if the operation was successful
                    let success = message.lowercased() == "avis added successfully" || message.lowercased() == "avis updated successfully"
                    completion(success, nil)
                } else {
                    completion(false, nil)
                }
            } catch {
                completion(false, error)
            }
        }.resume()
    }

    
    func convertFormField(named name: String, value: String, boundary: String) -> Data {
            var fieldData = Data()
            fieldData.append("--\(boundary)\r\n".data(using: .utf8)!)
            fieldData.append("Content-Disposition: form-data; name=\"\(name)\"\r\n\r\n".data(using: .utf8)!)
            fieldData.append("\(value)\r\n".data(using: .utf8)!)
            return fieldData
        }
        }

