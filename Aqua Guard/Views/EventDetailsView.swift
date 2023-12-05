//
//  EventDetailsView.swift
//  Aqua Guard
//
//  Created by Malek Labidi on 27/11/2023.
//

import SwiftUI

struct EventDetailsView: View {
    let event: Event

    var body: some View {

        VStack(alignment: .leading, spacing: 8) {
            // Event image
            AsyncImage(url: URL(string: "http://192.168.43.253:9090/images/event/\(event.eventImage)")) { phase in
                     switch phase {
                     case .empty:
                         ProgressView()
                     case .success(let image):
                         image
                             .resizable()
                             .aspectRatio(contentMode: .fill)
                             .frame(height: 200)
                             .clipped()
                     case .failure:
                         Image(systemName: "photo") // You can use a placeholder image here
                             .resizable()
                             .aspectRatio(contentMode: .fill)
                             .frame(height: 200)
                             .clipped()
                     @unknown default:
                         EmptyView()
                     }
                 }

            // event details
            VStack(alignment: .leading, spacing: 8) {
                // Event title
                Text(event.eventName)
                    .font(.title)
                    .fontWeight(.medium)

                // Event description
                Text(event.description)
                    .font(.body)
                    .foregroundColor(.secondary)

                // HStack for date, location, and info icons
                HStack {
                    VStack(alignment: .leading, spacing: 8) {
                        HStack {
                            // Calendar icon and event date
                            Image(systemName: "calendar")
                            Text("\(formatDate(event.dateDebut)) to \(formatDate(event.dateFin))")

                            .font(.body)
                            .fontWeight(.medium)
                        }
                        HStack {
                            // Location icon and event location
                            Image(systemName: "location")
                            Text(event.lieu)
                            .font(.body)
                            .fontWeight(.medium)
                        }
                                            
                    }
          
                   
                }
                
                
                Button(action: {
                   
                }) {
                    Text("Participate")
                        .font(.system(size: 20))
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .frame(height: 50)
                        .background(Color.lightBlue)
                        .cornerRadius(50)
                        .padding(.leading,0)
                      
                    
                }
                Button(action: {
                   
                }) {
                    Text("Cancel")
                        .font(.system(size: 20))
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                           .frame(height: 50)
                        .background(Color.red)
                        .cornerRadius(50)
                        .padding(.leading,0)
                      
                    
                }

            }
            .padding(16)
        }
        .background(Color.white)
        .cornerRadius(8)
        .shadow(radius: 4)
        .padding(8)
        .navigationBarTitle("Event Details", displayMode: .inline)
    }
}


/*
struct EventDetailsView_Previews: PreviewProvider {
    static var previews: some View {
        let sampleEvent = Event(
            idEvent: "1",
            userName: "John Doe",
            userImage: "john_image",
            eventName: "Sample Event",
            description: "This is a sample event description.",
            eventImage: "sidi_bou_said",
            dateDebut: Date(),
            dateFin: Date(),
            lieu: "Sample Location"
        )

        return EventDetailsView(event: sampleEvent)
            .previewLayout(.sizeThatFits)
            .padding()
    }
}*/
