//
//  Product.swift
//  AquaGuard shop
//
//  Created by HmedA on 30/11/2023.
//

import Foundation

struct Product: Identifiable {
    var id = UUID()
    var name: String
    var description: String
    var image: String
    var price: Int
    var quantity: Int
    var category: String

    init?(json: [String: Any]) {
        guard
            let id  = json["_id"] as? String,
            let name = json["name"] as? String,
            let description = json["description"] as? String,
            let image = json["image"] as? String,
            let price = json["price"] as? Int,
            let quantity = json["quantity"] as? Int,
            let category = json["category"] as? String
            
        else {
            return nil
        }
       
        self.name = name
        self.description = description
        self.image = image
        self.price = price
        self.quantity = quantity
        self.category = category
    }
    
}
