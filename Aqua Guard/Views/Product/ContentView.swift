//
//  ContentView.swift
//  AquaGuard shop
//
//  Created by Mohamed Kout on 30/11/2023.
//

import SwiftUI

struct ProductContentView: View {
    @StateObject var cartManager = CartManager()
    var columns = [GridItem(.adaptive(minimum: 160), spacing: 20)]
    
    var body: some View {
        NavigationView {
            ScrollView {
                LazyVGrid(columns: columns, spacing: 20) {
                    ForEach(productList, id: \.id) { product in
                        ProductCard(product: product)
                            .environmentObject(cartManager)
                    }
                }
                .padding()
            }
            .navigationTitle(Text("AquaGuard Shop"))
            .toolbar {
                NavigationLink {
                    CartView()
                        .environmentObject(cartManager)
                } label: {
                    CartButton(numberOfProducts: cartManager.products.count)
                }
            }
            .background(Image("background_splash_screen")
                .resizable()
                .scaledToFill(
                )
                    .edgesIgnoringSafeArea(.all))
        }
                
                     
        .navigationViewStyle(StackNavigationViewStyle())
      
    }
}

struct ProductContentView_Previews: PreviewProvider {
    static var previews: some View {
        ProductContentView()
    }
}
