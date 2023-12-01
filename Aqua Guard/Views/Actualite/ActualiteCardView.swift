//
//  ActualiteCardView.swift
//  Aqua Guard
//
//  Created by adem on 1/12/2023.
//

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
 
                    Spacer()     
                    NavigationLink( destination: ActualiteDetailsView()) {
                     }// Location icon and event location
                    Image(systemName: "square.and.arrow.up")
                        .foregroundColor(.blue) // Customize the color if needed
                        .font(.largeTitle)
                    
           

                 


                    

               
                   
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
