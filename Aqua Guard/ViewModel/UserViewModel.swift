//
//  UserViewModel.swift
//  Aqua Guard
//
//  Created by Amira Ben Mbarek on 13/12/2023.
//

import Foundation

class UserViewModel: ObservableObject{
    @Published var isDeleted: Bool = false
    @Published var email:String = ""
    @Published var code:String = ""
    @Published var error:String = ""
    @Published var sent: Bool = false
    @Published var verified: Bool = false

    func deleteAccount(id: String)  {
        Task {
            do {
                let (_,_) = try await UserService.makeRequest(endpoint: "/deleteUserById/" + id, method: "DELETE", body: nil)
                    isDeleted = true
                } catch {
                print("Error deleting account")
                    isDeleted = false
            }
        }
    }
    
    func sendEmail() async {
        
        var json = [String:Any]()
        json["email"] = email
        
        do {
            
            await MainActor.run {
                self.sent = true
            }
            
        let (responseData, response) = try await UserService.makeRequest(endpoint: "/sendActivationCode", method: "POST", body: json)


            let httpResponse = (response as? HTTPURLResponse)
        
        if(type(of: httpResponse!) != HTTPURLResponse.self){
            await MainActor.run {
                self.error = "Unexpected error!"
                self.sent = false

            }
        }
        
        if (httpResponse!.statusCode == 200) {
                await MainActor.run {
                self.error = ""
                self.sent = true
                }

        }
        else {
            await MainActor.run {
                self.error = "Email not found!"
                self.sent = false
                }
            }
                        
        }
        catch {
            await MainActor.run {
                self.error = "Unexpected error!"
                self.sent = false
            }
        }
        
    }
    
    func verifyCode() async{
        
        var json = [String:Any]()
        json["code"] = code
        
        do {
            
            await MainActor.run {
                self.sent = true
            }
            
        let (responseData, response) = try await UserService.makeRequest(endpoint: "/verifyCode", method: "POST", body: json)


            let httpResponse = (response as? HTTPURLResponse)
        
        if(type(of: httpResponse!) != HTTPURLResponse.self){
            await MainActor.run {
                self.error = "Unexpected error!"
                self.verified = false

            }
        }
        
        if (httpResponse!.statusCode == 200) {
                await MainActor.run {
                self.error = ""
                self.verified = true
                }

        }
        else {
            await MainActor.run {
                self.error = "wrong code!"
                self.verified = false
                }
            }
                        
        }
        catch {
            await MainActor.run {
                self.error = "Unexpected error!"
                self.verified = false
            }
        }
        
    }
    
    func resetPassword() async {
        
        var json = [String:Any]()
        json["code"] = code
        
        do {
            
            await MainActor.run {
                self.sent = true
            }
            
        let (responseData, response) = try await UserService.makeRequest(endpoint: "/verifyCode", method: "POST", body: json)


            let httpResponse = (response as? HTTPURLResponse)
        
        if(type(of: httpResponse!) != HTTPURLResponse.self){
            await MainActor.run {
                self.error = "Unexpected error!"
                self.verified = false

            }
        }
        
        if (httpResponse!.statusCode == 200) {
                await MainActor.run {
                self.error = ""
                self.verified = true
                }

        }
        else {
            await MainActor.run {
                self.error = "wrong code!"
                self.verified = false
                }
            }
                        
        }
        catch {
            await MainActor.run {
                self.error = "Unexpected error!"
                self.verified = false
            }
        }
        
    }
}
