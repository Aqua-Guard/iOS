//
//  EventCardView.swift
//  Aqua Guard
//
//  Created by Malek Labidi on 27/11/2023.
//

import SwiftUI

struct EventCardView: View {
    let event: Event

    var body: some View {
       
        VStack(alignment: .leading, spacing: 8) {
            // Event image
            AsyncImage(url: URL(string: "https://aquaguard-tux1.onrender.com/images/event/\(event.eventImage)")) { phase in
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
          
                    
                   
                    NavigationLink( destination: EventDetailsView(event: event)) {
                      
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

func formatDate(_ date: Date) -> String {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy-MM-dd" 
    return dateFormatter.string(from: date)
}


/*
struct EventCardView_Previews: PreviewProvider {
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

        return EventCardView(event: sampleEvent)
            .previewLayout(.sizeThatFits)
            .padding()
    }
}*/
