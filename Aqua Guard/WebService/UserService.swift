//
//  UserService.swift
//  Aqua Guard
//
//  Created by Amira Ben Mbarek on 5/12/2023.
//

import Foundation

let URLString:String = "http://172.18.1.232:9090/user"


class UserService{
    /*
    public static func desactivateAccount(endpoint:String, method:String, body:[String:Any]?) async throws -> (Data, URLResponse) {
        var responseData:Data?, response:URLResponse
        
        let url = URLString+endpoint
        let endpointUrl = URL(string: url)
        var request = URLRequest(url: endpointUrl!)
        
        request.httpMethod = method
        
        (responseData, response) = try await URLSession.shared.data(for: request)
        
        let httpResponse = (response as? HTTPURLResponse)

        
        return (responseData!, response)
        
    }
    */
    public static func makeRequest(endpoint:String, method:String, body:[String:Any]?) async throws -> (Data, URLResponse) {
        
        var responseData:Data?, response:URLResponse
        
        let url = URLString+endpoint
        let endpointUrl = URL(string: url)
        var request = URLRequest(url: endpointUrl!)
        
        request.httpMethod = method

        
        if(method != "GET" && method != "DELETE"){
            var data: Data?
            if(body != nil){
                data = try? JSONSerialization.data(withJSONObject: body!, options: [])
            }
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            request.addValue("application/json", forHTTPHeaderField: "Accept")
            
            (responseData, response) = try await URLSession.shared.upload(
                for: request,
                from: data!
            )
        }
        else {
            (responseData, response) = try await URLSession.shared.data(for: request)
        }
        
        let httpResponse = (response as? HTTPURLResponse)

        
        return (responseData!, response)
    }
    
    
    func register(user: UsersModel, image: Data) async throws -> Bool {
        let urlString = "\(URLString)/registerAndroidIOS"
            guard let url = URL(string: urlString)
        else {
                print("Invalid URL")
                return false
            }

            var request = URLRequest(url: url)
            request.httpMethod = "POST"

            let boundary = "Boundary-\(UUID().uuidString)"
            request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")


            var body = Data()

            // Append image data
        body.append("--\(boundary)\r\n")
        body.append("Content-Disposition: form-data; name=\"image\"; filename=\"image.jpg\"\r\n")
        body.append("Content-Type: image/jpeg\r\n\r\n")
        body.append(image)
        body.append("\r\n")

        body.append(convertFormField(named: "email", value: user.email, boundary: boundary))
        body.append(convertFormField(named: "firstName", value: user.firstName, boundary: boundary))
        body.append(convertFormField(named: "lastName", value: user.lastName, boundary: boundary))
        body.append(convertFormField(named: "username", value: user.username, boundary: boundary))
        body.append(convertFormField(named: "password", value: user.password, boundary: boundary))


            body.append("--\(boundary)--".data(using: .utf8)!)

            request.httpBody = body
        let (data, response) = try await URLSession.shared.data(for: request)

        guard let httpResponse = response as? HTTPURLResponse,
              httpResponse.statusCode == 201 else {
            throw URLError(.badServerResponse)
        }
        return true
        }
    
    
    func updateProfile(user: UpdateProfile, image: Data) async throws -> Bool {
        let urlString = "\(URLString)/updateProfile/" + (LoginViewModell.defaults.string(forKey: "username") ?? "")
            guard let url = URL(string: urlString)
        else {
                print("Invalid URL")
                return false
            }

            var request = URLRequest(url: url)
            request.httpMethod = "POST"

            let boundary = "Boundary-\(UUID().uuidString)"
            request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")


            var body = Data()

            // Append image data
        body.append("--\(boundary)\r\n")
        body.append("Content-Disposition: form-data; name=\"image\"; filename=\"image.jpg\"\r\n")
        body.append("Content-Type: image/jpeg\r\n\r\n")
        body.append(image)
        body.append("\r\n")

        body.append(convertFormField(named: "email", value: user.email, boundary: boundary))
        body.append(convertFormField(named: "firstName", value: user.firstName, boundary: boundary))
        body.append(convertFormField(named: "lastName", value: user.lastName, boundary: boundary))
        body.append(convertFormField(named: "username", value: user.username, boundary: boundary))


            body.append("--\(boundary)--".data(using: .utf8)!)

            request.httpBody = body
        let (data, response) = try await URLSession.shared.data(for: request)

        guard let httpResponse = response as? HTTPURLResponse,
              httpResponse.statusCode == 201 else {
            throw URLError(.badServerResponse)
        }
        return true
        }

    
    func convertFormField(named name: String, value: String, boundary: String) -> Data {
            var fieldData = Data()
            fieldData.append("--\(boundary)\r\n".data(using: .utf8)!)
            fieldData.append("Content-Disposition: form-data; name=\"\(name)\"\r\n\r\n".data(using: .utf8)!)
            fieldData.append("\(value)\r\n".data(using: .utf8)!)
            return fieldData
        }
    
    public static func RegisterRequest(endpoint:String, method:String, body:[String:Any]?, image: Data) async throws -> (Data, URLResponse) {
        
        var responseData:Data?, response:URLResponse
        
        let url = URLString+endpoint
        let endpointUrl = URL(string: url)
        var request = URLRequest(url: endpointUrl!)
        
        request.httpMethod = method
        
        if(method != "GET" && method != "DELETE"){
            var data: Data?
            if(body != nil){
                data = try? JSONSerialization.data(withJSONObject: body!, options: [])
            }
            
            let boundary = "Boundary-\(UUID().uuidString)"

            var request = URLRequest(url: endpointUrl!)
                    request.httpMethod = "POST"
                    request.addValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
            
            var httpBody = NSMutableData()

            httpBody.append(convertFileData(fieldName: "image",
                                            fileName: "image",
                                            mimeType: "image/jpeg",
                                            fileData: image,
                                            using: boundary))

            
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            request.addValue("application/json", forHTTPHeaderField: "Accept")
            
            (responseData, response) = try await URLSession.shared.upload(
                for: request,
                from: data!
            )
        }
        else {
            (responseData, response) = try await URLSession.shared.data(for: request)
        }
        
        
        return (responseData!, response)
    }
}

func convertFileData(fieldName: String, fileName: String, mimeType: String, fileData: Data, using boundary: String) -> Data {
    let data = NSMutableData()
    
    data.appendString("--\(boundary)\r\n")
    data.appendString("Content-Disposition: form-data; name=\"\(fieldName)\"; filename=\"\(fileName)\"\r\n")
    data.appendString("Content-Type: \(mimeType)\r\n\r\n")
    data.append(fileData)
    data.appendString("\r\n")
    
    return data as Data
}
    
    func convertFormField(named name: String, value: String, using boundary: String) -> String {
        var fieldString = "--\(boundary)\r\n"
        fieldString += "Content-Disposition: form-data; name=\"\(name)\"\r\n"
        fieldString += "\r\n"
        fieldString += "\(value)\r\n"
        
        return fieldString
    }


extension NSMutableData {
    func appendString(_ string: String) {
        if let data = string.data(using: .utf8) {
            self.append(data)
        }
    }
}
