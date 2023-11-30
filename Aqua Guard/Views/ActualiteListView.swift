//
//  ActualiteListView.swift
//  Aqua Guard
//
//  Created by ademseddik on 27/11/2023.
//

import SwiftUI

struct ActualiteListView: View {
    var body: some View {
    
        NavigationView {
            List {
             
                ForEach(0..<5) { index in
               
                    ActualiteCardView()
                        .listRowInsets(EdgeInsets(top: 5, leading: 5, bottom: 4, trailing: 5))
                }
            }
            .background(Image("background_splash_screen")
                            .resizable()
                            .scaledToFill()
                            .edgesIgnoringSafeArea(.all))
            .navigationTitle("Actualites").navigationBarTitleDisplayMode(.inline)
        }
    }
}
#Preview {
    ActualiteListView()
}
