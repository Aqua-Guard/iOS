//
//  StoreView.swift
//  Aqua Guard
//
//  Created by Mohamed Kout on 15/12/2023.
//

import Foundation
import SwiftUI

struct StoreView: View {
    @EnvironmentObject var cartManager: CartManager
    @ObservedObject var viewModel: ProductViewModel
    @State private var searchText = ""
    @State private var selectedCategory = ""
    @State private var selectedPriceRange: Int = 5000
    var columns = [GridItem(.adaptive(minimum: 160), spacing: 20)]
    @State private var isShowingProductDetail = false
    @State private var selectedProduct: Product?

    init(viewModel: ProductViewModel) {
        self.viewModel = viewModel
    }

    var body: some View {
        NavigationView {
            VStack {
                // Search Bar
                SearchBar(text: $searchText)
                    .padding(.horizontal)
                Text("Your Points Balance:\(LoginViewModell.defaults.string(forKey: "nbPts")!)")
                // Category Selector
                Picker(selection: $selectedCategory, label: Text("Category")) {
                    Text("All Categories")
                        .tag("")
                    ForEach(["Accessoires","Loisir","Materiel de Plongée","Hygiéne"], id: \.self) { category in
                        Text(category)
                            .tag(category)
                    }
                }
                .pickerStyle(MenuPickerStyle())
                .padding(.horizontal)

                // Price Range Slider
                Slider(value: Binding(
                                    get: { Double(selectedPriceRange) }, // Convert Int to Double
                                    set: { selectedPriceRange = Int($0) } // Convert Double to Int
                                ), in: 0...5000, step: 100)
                                .padding(.horizontal)

                                Text("Selected Price Range: \(selectedPriceRange)") // Remove Int conversion
                                    .padding(.horizontal)
                // Product Grid
                ScrollView {
                    LazyVGrid(columns: columns, spacing: 20) {
                        ForEach(viewModel.productList?.filter { product in
                            let nameMatches = product.name.lowercased().contains(searchText.lowercased()) || searchText.isEmpty
                            let categoryMatches = product.category == selectedCategory || selectedCategory.isEmpty
                            let priceInRange = product.price <= selectedPriceRange
                            return nameMatches && categoryMatches && priceInRange
                        } ?? [], id: \.id) { product in
                            ProductCard(viewModel: viewModel, product: product)
                                .environmentObject(cartManager)
                                .onTapGesture {
                                    selectedProduct = product
                                    isShowingProductDetail = true
                                }
                        }
                    }
                    .padding()
                }
            }
            .background(
                Image("background_splash_screen")
                    .resizable()
                    .scaledToFill()
                    .edgesIgnoringSafeArea(.all)
            )
            .sheet(isPresented: $isShowingProductDetail) {
                if let selectedProduct = selectedProduct {
                    ProductDetailView(product: selectedProduct)
                        .environmentObject(cartManager)
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarTitle("AquaGuard Shop")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    NavigationLink(destination: CartView().environmentObject(cartManager)) {
                        CartButton(numberOfProducts: cartManager.products.count)
                    }
                }
            }
        }
        .onAppear() {
            Task {
                viewModel.fetchProducts()
            }
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
}

