//
//  SearchBar.swift
//  AquaGuard shop
//
//  Created by Mohamed Kout on 14/12/2023.
//

import SwiftUI

struct SearchBar: View {
    @Binding var text: String
    
    var body: some View {
        HStack {
            TextField("Product Name", text: $text)
                .padding(8)
                .background(Color.white.opacity(0.2))
                .cornerRadius(8)
            
            Button(action: {
                text = ""
            }) {
                Image(systemName: "xmark.circle.fill")
                    .foregroundColor(.gray)
            }
            .padding(.trailing, 8)
            .opacity(text.isEmpty ? 0 : 1)
        }
        .padding()
    }
}
