//
//  CartView.swift
//  Aqua Guard
//
//  Created by Mohamed Kout on 15/12/2023.
//

import Foundation
import SwiftUI
struct CartView: View {
    @EnvironmentObject var cartManager: CartManager
    let viewModel = ProductViewModel()

    var body: some View {
        ScrollView {
            if cartManager.paymentSuccess {
                Text("Thank you for your purchase. Please wait for our email for the validation of your order. You can download your payment invoice.")
                    .padding()

                if let fileURL = cartManager.fileURL {
                    Button("Download Invoice") {
                        downloadPDF(at: fileURL)
                    }
                }
            } else {
                if cartManager.products.count > 0 {
                    ForEach(cartManager.products, id: \.id) { product in
                        ProductRow(viewModel: viewModel, product: product)
                    }
                    
                    HStack {
                        Text("Your cart total is")
                        Spacer()
                        Text("\(cartManager.total).00 PT")
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
        .background(
            Image("background_splash_screen")
                .resizable()
                .scaledToFill()
                .edgesIgnoringSafeArea(.all)
        )
        
    }

    private func downloadPDF(at url: URL) {
        let fileManager = FileManager.default
        let documentsDirectory = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first
        let uniqueFilename = UUID().uuidString + "_" + url.lastPathComponent
        let destinationURL = documentsDirectory?.appendingPathComponent(uniqueFilename)
        
        do {
            try fileManager.copyItem(at: url, to: destinationURL!)
            let activityViewController = UIActivityViewController(activityItems: [destinationURL!], applicationActivities: nil)
            if let window = UIApplication.shared.windows.first {
                activityViewController.popoverPresentationController?.sourceView = window
                activityViewController.popoverPresentationController?.sourceRect = CGRect(x: window.bounds.midX, y: window.bounds.midY, width: 0, height: 0)
            }
            // Present the activity view controller
            UIApplication.shared.keyWindow?.rootViewController?.present(activityViewController, animated: true, completion: nil)
        } catch {
            print("Failed to download PDF file: \(error)")
        }
    }
}
