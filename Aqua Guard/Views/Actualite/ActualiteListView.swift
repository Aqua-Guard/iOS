//
//  ActualiteListView.swift
//  Aqua Guard
//
//  Created by adem on 1/12/2023.
//

import SwiftUI

struct ActualiteListView: View {
    var body: some View {
        VStack {
        NavigationView {
            List {
             
                ForEach(0..<5) { index in
               
                    ActualiteCardView()
                        .listRowInsets(EdgeInsets(top: 5, leading: 0, bottom: 4, trailing: 0))
                }
            }
            .padding(8)
                       .listStyle(PlainListStyle()) // Use PlainListStyle to remove the default list appearance
                       
            .background(Image("background_splash_screen")
                            .resizable()
                            .scaledToFill()
                            .edgesIgnoringSafeArea(.all))
            .navigationTitle("Actualites").navigationBarTitleDisplayMode(.inline)
        }
    }
    } }
#Preview {
    ActualiteListView()
}
