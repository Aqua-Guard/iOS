//
//  EventListView.swift
//  Aqua Guard
//
//  Created by Malek Labidi on 27/11/2023.
//

import SwiftUI

struct EventListView: View {
    var body: some View {
    
        NavigationView {
            List {
             
                Section(header: Text("No Events").font(.title).foregroundColor(Color.darkBlue), footer: Text("")) {
                 
                    Image("calendar_amico")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 250, height: 250)
                        .padding(.top, 5)

                    
                    Text("No Events exists")
                        .font(.system(size: 20))
                        .foregroundColor(Color.darkBlue)
                        .multilineTextAlignment(.center)
                        .padding(.top, 5)
                }

               
                ForEach(0..<5) { index in
               
                    EventCardView()
                        .listRowInsets(EdgeInsets(top: 5, leading: 5, bottom: 4, trailing: 4))
                }
            }
         
            .navigationBarTitle("Events").navigationBarTitleDisplayMode(.inline)
        }
        .background(Image("background_splash_screen")
                                 .resizable()
                                 .scaledToFill()
                                 .edgesIgnoringSafeArea(.all))
    }
}


#Preview {
    EventListView()
}
