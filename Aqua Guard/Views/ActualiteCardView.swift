//
//  ActualiteCardView.swift
//  Aqua Guard
//
//  Created by ademseddik on 27/11/2023.
//ActualiteCardView

import SwiftUI

struct ActualiteCardView: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            // Event image
            Image("photo")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(height: 200)
                .clipped()

            // event details
            VStack(alignment: .leading, spacing: 8) {
                // Event title
                Text("Title")
                    .font(.title)
                    .fontWeight(.medium)

                // Event description
                Text("Description")
                    .font(.body)
                    .foregroundColor(.secondary)

                // HStack for date, location, and info icons
                HStack (){
 
                    Spacer()                    // Location icon and event location
                    Image("share")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 28)
                    
                    // Button with the "info.circle" icon
                   NavigationLink( destination: ActualiteDetailsView()) {
                    }
                 


                    

               
                   
                }
            }
            .padding(16)
        }
        .background(Color.white)
        .cornerRadius(8)
        .shadow(radius: 4)
        .padding(8)
    }
}

#Preview {
    ActualiteCardView()
}
