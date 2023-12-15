//
//  LoginViewModel.swift
//  Aqua Guard
//
//  Created by Amira Ben Mbarek on 11/30/23.
//

import Foundation
import LocalAuthentication
import SwiftUI

class LoginViewModell: ObservableObject {
    @Published var username:String = ""
    @Published var password:String = ""
    @Published var usernameError:String = ""
    @Published var passwordError:String = ""
    @Published private(set) var error: String?
    @Published var loggingIn: Bool = false
    let emailValidationRegex = "^\\w+([\\.-]?\\w+)*@\\w+([\\.-]?\\w+)*(\\.\\w{2,7})+$"
    static let defaults = UserDefaults.standard

    func login() async {

        var json = [String:Any]()
        json["username"] = username
        json["password"] = password
        
        do {
            
            await MainActor.run {
                self.loggingIn = true
            }
            
        let (responseData, response) = try await UserService.makeRequest(endpoint: "/login", method: "POST", body: json)


            let httpResponse = (response as? HTTPURLResponse)
        
        if(type(of: httpResponse!) != HTTPURLResponse.self){
            await MainActor.run {
                self.error = "Unexpected error!"
                self.loggingIn = false

            }
        }
        
        if (httpResponse!.statusCode == 200) {
            if (try? JSONDecoder().decode(LoginResponse.self, from: responseData)) != nil {
                if let loginResponse = try? JSONDecoder().decode(LoginResponse.self, from: responseData) {


                    LoginViewModell.defaults.set(loginResponse.token, forKey: "token")
                    LoginViewModell.defaults.set(loginResponse.email, forKey: "email")
                    LoginViewModell.defaults.set(loginResponse.username, forKey: "username")
                    LoginViewModell.defaults.set(loginResponse.firstName, forKey: "firstName")
                    LoginViewModell.defaults.set(loginResponse.lastName, forKey: "lastName")
                    LoginViewModell.defaults.set(loginResponse.nbPts, forKey: "nbPts")
                    LoginViewModell.defaults.set(loginResponse.image, forKey: "image")
                    LoginViewModell.defaults.set(loginResponse.role, forKey: "role")
                    LoginViewModell.defaults.set(loginResponse.id, forKey: "id")
                }
                await MainActor.run {
                self.error = ""
                self.loggingIn = true
                }
                
                print(LoginViewModell.defaults.string(forKey: "image"))
                print(LoginViewModell.defaults.string(forKey: "username"))
                                
            }

        }
        else {
            await MainActor.run {
                self.error = "Invalid Credentials!"
                self.loggingIn = false
                }
            }
                        
        }
        catch {
            await MainActor.run {
                self.error = "Unexpected error!"
                self.loggingIn = false
            }
        }
        
    }
    
    func validate() {
        if (username == ""){
            usernameError = "This field is required!"
        }
        else {
            usernameError = ""
        }
        
        if (password == ""){
            passwordError = "This field is required!"
        }
        else {
            passwordError = ""
        }
    }
    
    static func logout() {
            UserDefaults.standard.removeObject(forKey: "token")
            UserDefaults.standard.removeObject(forKey: "email")
            UserDefaults.standard.removeObject(forKey: "username")
            UserDefaults.standard.removeObject(forKey: "nbPts")
            UserDefaults.standard.removeObject(forKey: "image")
            UserDefaults.standard.removeObject(forKey: "role")
            UserDefaults.standard.removeObject(forKey: "id")
        }
}
