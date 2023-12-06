//
//  Product.swift
//  AquaGuard shop
//
//  Created by Mohamed Kout on 30/11/2023.
//

import Foundation

struct Product: Identifiable {
    var id = UUID()
    var name: String
    var image: String
    var price: Int
}

var productList = [Product(name: "Palmes", image: "palmes", price: 54),
                   Product(name: "Masque et Toyeau de plongé",image:"masquetoyeau",price:89),
                   Product(name: "Combinaison de plongé", image: "combinaison", price:79),
                   Product(name: "Lunette Soleil", image: "lunettesoleil", price: 94),
                   Product(name: "Sac à dos recyclé", image: "sacados", price: 99),
                   Product(name: "Sac à main recyclé", image: "sacamain", price: 65),
                   Product(name: "Lot de sachets recyclées", image: "sachet", price: 54),]

