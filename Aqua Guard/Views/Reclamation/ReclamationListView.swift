//
//  ReclamationListView.swift
//  Aqua Guard
//
//  Created by adem on 1/12/2023.
//

import SwiftUI

struct ReclamationListView: View {
        var body: some View {
            NavigationView {
               VStack {
                   List {
                       ForEach(0..<5) { index in
                      
                           ReclamationCardView()
                               .listRowInsets(EdgeInsets(top: 5, leading: 0, bottom: 4, trailing: 0))
                       }
                   }
                   .padding(8)
                   .listStyle(PlainListStyle()) // Use PlainListStyle to remove the default list appearance
                   .navigationTitle("Reclamation").navigationBarTitleDisplayMode(.inline)
               }
                
               }
           }
       }
#Preview {
    ReclamationListView()
}
