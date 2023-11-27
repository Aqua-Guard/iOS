//
//  EventDetailsView.swift
//  Aqua Guard
//
//  Created by Malek Labidi on 27/11/2023.
//

import SwiftUI

struct EventDetailsView: View {
    var body: some View {
       
        VStack(alignment: .leading, spacing: 8) {
            // Event image
            Image("sidi_bou_said")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(height: 200)
                .clipped()

            // event details
            VStack(alignment: .leading, spacing: 8) {
                // Event title
                Text("clean - up")
                    .font(.title)
                    .fontWeight(.medium)

                // Event description
                Text("Une initiative communautaire pour nettoyer les plages et protéger l'environnement.")
                    .font(.body)
                    .foregroundColor(.secondary)

                // HStack for date, location, and info icons
                HStack {
                    // Calendar icon and event date
                    Image(systemName: "calendar")
                    Text("2023-11-11 to 2023-11-12")
                        .font(.body)
                        .fontWeight(.medium)

                    // Location icon and event location
                    Image(systemName: "location")
                    Text("location")
                        .font(.body)
                        .fontWeight(.medium)
                
                }
                
                
                Button(action: {
                   
                }) {
                    Text("Participate")
                        .font(.system(size: 20))
                        .foregroundColor(.white)
                        // Set your color
                        .frame(width: 148, height: .infinity)
                        .background(Color.lightBlue)
                        .cornerRadius(50)
                        .padding(.leading,20)
                      
                    
                }
                Button(action: {
                   
                }) {
                    Text("Cancel")
                        .font(.system(size: 20))
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity) // Make the button full width
                           .frame(height: 50) // Set your desired height
                        .background(Color.red)
                        .cornerRadius(50)
                        .padding(.leading,20)
                      
                    
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
    EventDetailsView()
}
