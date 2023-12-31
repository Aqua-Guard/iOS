//
//  ProductService.swift
//  AquaGuard shop
//
//  Created by Hmeda on 7/12/2023.
//

import Foundation

class ProductService {
    static let shared = ProductService()
    private let baseURL = "http://172.18.26.15:9090"
        
    func fetchProducts(completion: @escaping ([Product]?) -> Void) {
         let url = URL(string: "\(baseURL)/produit")!
        
        let request = URLRequest(url: url)
        
        URLSession.shared.dataTask(with: request) { data, response, error in
                guard let data = data, error == nil else {
                    print("Error fetching produit:", error?.localizedDescription ?? "Unknown error")
                    completion(nil)
                    return
                }

             do {
                 if let jsonArray = try JSONSerialization.jsonObject(with: data, options: []) as? [[String: Any]] {
                     print("jsonArray-----------")
                     print(jsonArray)
                     let produits = jsonArray.compactMap {
                        Product(json: $0) }
                     print("produits---------------")
                     print(produits)
                     completion(produits)
                 } else {
                     completion(nil)
                 }
             } catch let error{
                 print("*****User creation failed with error: \(error)")
                 completion(nil)
             }
         }.resume()
     }
    
    
    // Fetch product details by ID
       func fetchProductDetails(id: String, completion: @escaping (Product?) -> Void) {
           let url = URL(string: "\(baseURL)/produit/detail?id=\(id)")!

           URLSession.shared.dataTask(with: url) { data, response, error in
               guard let data = data, error == nil else {
                   completion(nil)
                   return
               }

               do {
                   if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                       if let product = Product(json: json) {
                           completion(product)
                       } else {
                           completion(nil)
                       }
                   } else {
                       completion(nil)
                   }
               } catch {
                   completion(nil)
               }
           }.resume()
       }
}

