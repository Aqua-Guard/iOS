//
//  CartView.swift
//  AquaGuard shop
//
//  Created by Mohamed Kout on 30/11/2023.
//


import SwiftUI

struct CartView: View {
    @EnvironmentObject var cartManager: CartManager
    
    var body: some View {
        ScrollView {
            if cartManager.paymentSuccess {
                Text("Thanks for your purchase!")
                    .padding()
            } else {
                if cartManager.products.count > 0 {
                    ForEach(cartManager.products, id: \.id) { product in
                        ProductRow(product: product)
                    }
                    
                    HStack {
                        Text("Your cart total is")
                        Spacer()
                        Text("$\(cartManager.total).00")
                            .bold()
                    }
                    .padding()
                    
                    PaymentButton(action: cartManager.pay)
                        .padding()
                    
                    
                } else {
                    Text("Your cart is empty.")
                }
            }
        }

        .navigationTitle(Text("My Cart"))
        .padding(.top)
        .onDisappear {
            if cartManager.paymentSuccess {
                cartManager.paymentSuccess = false
                
            }
     
        }
        .background(Image("background_splash_screen")
                
                .scaledToFill(
                )
                    .edgesIgnoringSafeArea(.all))
    }
}

struct CartView_Previews: PreviewProvider {
    static var previews: some View {
        ZStack(){
            CartView()
                .environmentObject(CartManager())
        }

    }
}
