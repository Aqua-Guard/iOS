import Foundation
import SwiftUI
struct ProductCard: View {
    @EnvironmentObject var cartManager: CartManager
    @ObservedObject var viewModel: ProductViewModel
    var product: Product

    var body: some View {
        VStack(spacing: 10) {
            ZStack(alignment: .topTrailing) {
                AsyncImage(url: URL(string: "http://172.18.26.15:9090/images/produit/\(product.image)")) { image in
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 180, height: 180)
                        .cornerRadius(20)
                } placeholder: {
                    Rectangle()
                        .foregroundColor(.gray)
                        .cornerRadius(20)
                }

                Button(action: {
                    addToCart()
                }) {
                    Image(systemName: "plus")
                        .padding(10)
                        .foregroundColor(.white)
                        .background(.black)
                        .cornerRadius(50)
                }
                .offset(x: 2, y: 10) // Adjust the position of the plus sign
            }

            VStack(alignment: .leading, spacing: 8) {
                Text(product.name)
                    .bold()

                Text("\(product.price)PT")
                    .font(.caption)
            }
            .padding()
            .frame(width: 180, alignment: .leading)
            .background(.ultraThinMaterial)
            .cornerRadius(20)
        }
    }

    private func addToCart() {
        cartManager.addToCart(product: product)
    }
}
