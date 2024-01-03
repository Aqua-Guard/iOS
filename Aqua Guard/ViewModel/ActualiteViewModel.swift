//
//  ActualiteViewModel.swift
//  Aqua Guard
//
//  Created by ademseddik on 6/12/2023.
//

import Foundation



class ActualiteViewModel: ObservableObject {

    @Published var actualites :[Actualite] = []
    
    let token = LoginViewModell.defaults.string(forKey: "token") ?? ""

    init() {
        fetchActualite()        // Initialize the list of Actualite with default data
    }
   

    func fetchActualite() {
       
        ActualiteWebService.shared.fetchactualite(token: token) { [weak self] actualites in
            
            DispatchQueue.main.async {
                self?.actualites = actualites ?? []
            }
        }
    }
    func searchActualites(about: String) {
         ActualiteWebService.shared.searchActualites(token: token,about: about) { [weak self] actualites in
             DispatchQueue.main.async {
                 self?.actualites = actualites ?? []
             }
         }
     }
   
}

