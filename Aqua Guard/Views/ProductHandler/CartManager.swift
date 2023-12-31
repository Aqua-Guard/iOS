//
//  CartManager.swift
//  Aqua Guard
//
//  Created by Mohamed Kout on 15/12/2023.
//

import Foundation
import SwiftUI
import PDFKit
import UIKit

class CartManager: ObservableObject {
    @Published private(set) var products: [Product] = []
    @Published private(set) var total: Int = 0
    var paymentSuccess: Bool = false // Update the type to Bool
    let paymentHandler = PaymentHandler()
    var fileURL: URL? // Add fileURL property to hold the PDF file URL? // Add fileURL property to hold the PDF file URL

    func addToCart(product: Product) {
        products.append(product)
        total += product.price
    }
    
    func removeFromCart(product: Product) {
        products = products.filter { $0.id != product.id }
        total -= product.price
    }
    
    func generatePDF() -> URL? {
        let pdfDocument = PDFDocument()
        let pageRect = CGRect(x: 0, y: 0, width: 612, height: 792)
        let fileName = "productListmock.pdf"
        
        guard let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {
            print("Failed to access documents directory.")
            return nil
        }
        let fileURL = documentsDirectory.appendingPathComponent(fileName)
        UIGraphicsBeginPDFContextToFile(fileURL.path, pageRect, nil)
        UIGraphicsBeginPDFPageWithInfo(pageRect, nil)
        
        // Draw content onto the PDF page
        let titleText = "Invoice"
        let pageWidth: CGFloat = 612 // Width of the page
        let titleFont = UIFont.systemFont(ofSize: 24) // Font for the title text

        let titleTextSize = (titleText as NSString).size(withAttributes: [NSAttributedString.Key.font: titleFont])
        let titleTextRect = CGRect(x: (pageWidth - titleTextSize.width) / 2, y: 50, width: titleTextSize.width, height: titleTextSize.height)
        let titleTextAttributes = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 24)]
        titleText.draw(in: titleTextRect, withAttributes: titleTextAttributes)
        
        let productListText = "Product List:"
        let productListTextRect = CGRect(x: 50, y: 100, width: 200, height: 50)
        let productListTextAttributes = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 18)]
        productListText.draw(in: productListTextRect, withAttributes: productListTextAttributes)
        
        var currentY: CGFloat = productListTextRect.origin.y + productListTextRect.size.height + 10
        
        for product in products {
            let productText = "- \(product.name), Price: \(product.price)PT"
            let productTextRect = CGRect(x: 50, y: currentY, width: 400, height: 30)
            let productTextAttributes = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14)]
            productText.draw(in: productTextRect, withAttributes: productTextAttributes)
            
            currentY += productTextRect.size.height + 5
        }
        
        let totalText = "Total Price:\(total) PT"
        let totalTextRect = CGRect(x: 50, y: currentY, width: 200, height: 50)
        let totalTextAttributes = [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 16)]
        totalText.draw(in: totalTextRect, withAttributes: totalTextAttributes)
        
        UIGraphicsEndPDFContext()
        
        return fileURL
    }

    // Call the function to generate the PDF

    func pay() {
        paymentHandler.startPayment(products: products, total: total) { [weak self] success in
            DispatchQueue.main.async {
                if success {
                    self?.fileURL = self?.generatePDF()
                    self?.paymentSuccess = true
                } else {
                    self?.paymentSuccess = false
                }
                self?.products = []
                self?.total = 0
                
                // Call the function to generate the PDF
                if let pdfURL = self?.fileURL {
                    print("PDF generated successfully at \(pdfURL.path)")
                } else {
                    print("Failed to generate PDF.")
                }
            }
        }
    }
    }
