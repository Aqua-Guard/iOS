//
//  UserViewModel.swift
//  Aqua Guard
//
//  Created by Amira Ben Mbarek on 13/12/2023.
//

import Foundation
//import GoogleSignIn

class UserViewModel: ObservableObject{
    @Published var isDeleted: Bool = false
    @Published var email:String = ""
    @Published var code:String = ""
    @Published var newPassword:String = ""
    @Published var oldPassword:String = ""
    @Published var confirmPassword:String = ""
    @Published var error:String = ""
    @Published var sent: Bool = false
    @Published var verified: Bool = false
    @Published var reset: Bool = false
    @Published var changed: Bool = false

    @Published var firstName:String = ""
    @Published var lastName:String = ""
    @Published var image:Data!
    @Published var username:String = ""
    @Published var firstNameError:String = ""
    @Published var lastNameError:String = ""
    @Published var emailError:String = ""
    @Published var usernameError:String = ""
    @Published var isLoading: Bool = false
    @Published var reqError: String = ""
    let userService = UserService()
    
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
        json["resetCode"] = code
        json["email"] = LoginViewModell.defaults.string(forKey: "resetEmail")
        
        do {
            
            await MainActor.run {
                self.verified = true
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
        json["newPassword"] = newPassword
        json["confirmPassword"] = confirmPassword
        json["email"] = LoginViewModell.defaults.string(forKey: "resetEmail")

        do {
            
            await MainActor.run {
                self.reset = true
            }
            
        let (responseData, response) = try await UserService.makeRequest(endpoint: "/forgotPassword", method: "POST", body: json)


            let httpResponse = (response as? HTTPURLResponse)
        
        if(type(of: httpResponse!) != HTTPURLResponse.self){
            await MainActor.run {
                self.error = "Unexpected error!"
                self.reset = false

            }
        }
        
        if (httpResponse!.statusCode == 200) {
                await MainActor.run {
                self.error = ""
                self.reset = true
                }

        }
        else {
            await MainActor.run {
                self.error = "wrong passwords!"
                self.reset = false
                }
            }
                        
        }
        catch {
            await MainActor.run {
                self.error = "Unexpected error!"
                self.reset = false
            }
        }
        
    }
    
    func changePassword() async {
        
        var json = [String:Any]()
        json["oldPassword"] = oldPassword
        json["newPassword"] = newPassword
        json["confirmPassword"] = confirmPassword
        json["email"] = LoginViewModell.defaults.string(forKey: "email")

        do {
            
            await MainActor.run {
                self.changed = true
            }
            
        let (responseData, response) = try await UserService.makeRequest(endpoint: "/changePassword", method: "POST", body: json)


            let httpResponse = (response as? HTTPURLResponse)
        
        if(type(of: httpResponse!) != HTTPURLResponse.self){
            await MainActor.run {
                self.error = "Unexpected error!"
                self.changed = false

            }
        }
        
        if (httpResponse!.statusCode == 200) {
                await MainActor.run {
                self.error = ""
                self.changed = true
                }

        }
        else if (httpResponse!.statusCode == 500){
            await MainActor.run {
                self.error = "Check old password again!"
                self.changed = false
                }
            }
        else {
            await MainActor.run {
                    self.error = "Passwords don't match!"
                    self.changed = false
                    }
                }
                        
        }
        catch {
            await MainActor.run {
                self.error = "Unexpected error!"
                self.changed = false
            }
        }
        
    }
    /*
    func googleLog(){
        guard let presentingViewController = (UIApplication.shared.connectedScenes.first as? UIWindowScene)?.windows.first?.rootViewController else {return}
       
        let signInConfig = GIDConfiguration.init(clientID: "530379865209-79okd7dct9g3j5kmt9q9fs3aa37r8m1n.apps.googleusercontent.com")
        GIDSignIn.sharedInstance.signIn(
            with: signInConfig,
            presenting: presentingViewController,
            callback: { user, error in
                if let error = error {
                    if(error.localizedDescription != "The user canceled the sign-in flow."){
                        self.error = "error: \(error.localizedDescription)"
                    }
                }
                if(GIDSignIn.sharedInstance.currentUser != nil){
                    Task {
                        await self.sendToken(token: GIDSignIn.sharedInstance.currentUser!.authentication.idToken!, social: "google")
                        GIDSignIn.sharedInstance.signOut()
                    }
                }
            }
        )
    }
    */
    
    
    func updateProfile(email: String, firstName: String, lastName: String, image: Data, username: String) async {
        if let imageURL = URL(string: image.base64EncodedString()) {
            
            let User = UpdateProfile(id: UUID().uuidString, email: email, firstName: firstName, lastName: lastName, username: username, image: imageURL.path())
            
            do {
                print("----------------------------------------------+++++++++++++")
                print(email)
                print(username)
                print(firstName)
                print(lastName)
                LoginViewModell.defaults.set(email, forKey: "email")
                LoginViewModell.defaults.set(username, forKey: "username")
                LoginViewModell.defaults.set(firstName, forKey: "firstName")
                LoginViewModell.defaults.set(lastName, forKey: "lastName")
                
                try await userService.updateProfile(user: User, image: image)
                



                
            } catch {
                print("Error creating account: \(error)")
            }

        } else {
            print("Invalid image URL")
        }
    }
}
