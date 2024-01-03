//
//  ReclamationViewModel.swift
//  Aqua Guard
//
//  Created by Mac Mini 5 on 14/12/2023.
//

import Foundation



class ReclamationViewModel: ObservableObject {
    
    @Published var discussions: [Discussion] = []
    @Published var reclamation :[Reclamation] = []
    @Published var createdwithSucsess: Bool = false
    @Published var alertMessageaddingreclamation: String = ""
    @Published var addingreclamationAlert: Bool = false

    
    
    @Published var CurrentUserId : String = LoginViewModell.defaults.string(forKey: "id") ?? ""
  

    let token = LoginViewModell.defaults.string(forKey: "token") ?? ""
    
    init() {
        fetchreclamation()        // Initialize the list of Actualite with default data
    }
   

    func fetchreclamation() {
       
        ReclamationWebService.shared.fetchreclamation(token: token) { [weak self] reclamation in
            DispatchQueue.main.async {
                self?.reclamation = reclamation ?? []
            }
        }
    }
    
    func fetchDiscussions(reclamationId: String) {
        ConversationWebService.shared.fetchDiscussions(token: token,reclamationId: reclamationId) { [weak self] discussions in
            DispatchQueue.main.async {
                self?.discussions = discussions ?? []
            }
        }
    }
    func sendMessage(message: String, userRole: String, reclamationId: String) async {
            do {
                let success = try await ConversationWebService.sendmessage(token: token,message: message, userRole: userRole, reclamationid: reclamationId)

                if success {
                    fetchDiscussions(reclamationId: reclamationId)
                }
            } catch {
                // Handle errors if needed
                print("Failed to send message:", error)
            }
        }
    func AddReclamation(title: String,description: String, image: Data) async {
        
        
            do {
                let success = try await ReclamationWebService.AddReclamation(token: token , userId : CurrentUserId ,title: title, description: description, imageData: image)

                if success {
                    
                    // Assuming getPosts() is already implemented and it updates the 'posts' array.
                     fetchreclamation()
                    DispatchQueue.main.async {
                                   self.createdwithSucsess = true
                    }
                }
            } catch {
                DispatchQueue.main.async {
                    if (description.split(separator: " ").count < 3) {
                        self.alertMessageaddingreclamation = "Description is too short."
                    }
                    else{
                        self.alertMessageaddingreclamation = "The description contains inappropriate language."
                    }
                  
                    self.addingreclamationAlert = true
                    
                }
            }
        }
    
   
}

