//
//  ProductDetailView.swift
//  Aqua Guard
//
//  Created by Mohamed Kout on 15/12/2023.
//

import Foundation
import SwiftUI

struct ProductDetailView: View {
    @EnvironmentObject var cartManager: CartManager
    var product: Product
    
    var body: some View {
        ZStack {
            Image("background_splash_screen")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .edgesIgnoringSafeArea(.all)
            
            VStack {
                Spacer()
                
                VStack(alignment: .center, spacing: 16) {
                    AsyncImage(url: URL(string: "https://aquaguard-tux1.onrender.com/images/produit/\(product.image)")) { image in
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 240, height: 240)
                            .cornerRadius(20)
                    } placeholder: {
                        Rectangle()
                            .foregroundColor(.gray)
                            .cornerRadius(20)
                    }
                    
                    Text(product.name)
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundColor(.black)
                        .padding(.top)
                    
                    VStack(alignment: .leading, spacing: 8) {
                        HStack {
                            Text("Description:")
                                .font(.headline)
                                .foregroundColor(.black)
                            Text(product.description)
                                .font(.subheadline)
                                .foregroundColor(.black)
                        }
                        .alignmentGuide(.leading) { _ in
                                                return 0
                                            }
                        HStack {
                            Text("Quantity:")
                                .font(.headline)
                                .foregroundColor(.black)
                            Text("\(product.quantity) Available items")
                                .font(.subheadline)
                                .foregroundColor(.black)
                        }
                        
                        HStack {
                            Text("Price:")
                                .font(.headline)
                                .foregroundColor(.black)
                            Text("\(product.price)  PT")
                                .font(.subheadline)
                                .foregroundColor(.black)
                        }
                        
                        HStack {
                            Text("Category:")
                                .font(.headline)
                                .foregroundColor(.black)
                            Text(product.category)
                                .font(.subheadline)
                                .foregroundColor(.black)
                        }
                    }
                    .padding(.horizontal)
                }
                .padding()
                .background(Color.white)
                .cornerRadius(20)
                
                Button(action: {
                    addToCart()
                }) {
                    Text("Add to Cart")
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.blue)
                        .cornerRadius(12)
                        .padding(.horizontal)
                }
                
                Spacer()
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarTitle(product.name)
    }
    
    private func addToCart() {
        cartManager.addToCart(product: product)
    }
}
