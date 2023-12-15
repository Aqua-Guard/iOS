//
//  ProductViewModel.swift
//  AquaGuard shop
//
//  Created by Hmeda on 7/12/2023.
//
import Foundation


class ProductViewModel: ObservableObject {
    @Published var productList: [Product]?

    func fetchProducts() {
        ProductService.shared.fetchProducts { [weak self] products in
            DispatchQueue.main.async {
                self?.productList = products
            }
        }
    }

    func fetchProductDetails(id: String, completion: @escaping (Product?) -> Void) {
        ProductService.shared.fetchProductDetails(id: id) { product in
            DispatchQueue.main.async {
                completion(product)
            }
        }
    }
}

