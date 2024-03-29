//
//  EventDetailsView.swift
//  Aqua Guard
//
//  Created by Malek Labidi on 27/11/2023.
//

import SwiftUI
import MapKit

struct EventDetailsView: View {
    let event: Event
    @Environment(\.presentationMode) var presentationMode

    @StateObject var participationViewModel = ParticipationViewModel()

    @State private var showAlertadd = false
    @State private var showAlertdelete = false

    @State private var isParticipated = false
    @State private var showSnackbar = false
    @State private var snackbarText = ""
    @State private var isMapSheetPresented = false

    
    private func checkIfParticipated() {
        Task {
            isParticipated = try await participationViewModel.isParticipated(eventId: event.idEvent)
        }
    }

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
                        Button(action: {
                                 isMapSheetPresented.toggle()
                             }) {
                                 HStack {
                                     Image(systemName: "location")
                                     Text(event.lieu)
                                         .font(.body)
                                         .fontWeight(.medium)
                                 }
                             }
                             .buttonStyle(PlainButtonStyle())
                             .sheet(isPresented: $isMapSheetPresented) {
                                 MapSheetView(eventLocation: event.lieu)
                             }
                        
                    }
                    
                    
                }
                if (isParticipated == true){
                    Button(action: {
                        showAlertdelete = true
                    }) {
                        Text("Cancel Participation")
                            .font(.system(size: 20))
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .frame(height: 50)
                            .background(Color.red)
                            .cornerRadius(50)
                            .padding(.leading,0)
                    }
                    .alert(isPresented: $showAlertdelete) {
                        Alert(
                            title: Text("Confirm Cancellation"),
                            message: Text("Are you sure you want to cancel your participation in this event?"),
                            primaryButton: .default(Text("Yes")) {
                                participationViewModel.deleteParticipation(eventId: event.idEvent)
                                showSnackbar = true
                                snackbarText = "Participation canceled!"
                                presentationMode.wrappedValue.dismiss()

                                
                            },
                            secondaryButton: .cancel()
                        )
                    }
                    .padding()
                }else{
                    Button(action: {
                        showAlertadd = true
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
                    .alert(isPresented: $showAlertadd) {
                        Alert(
                            title: Text("Confirm Participation"),
                            message: Text("Are you sure you want to participate in this event?"),
                            primaryButton: .default(Text("Yes")) {
                                participationViewModel.addParticipation(eventId: event.idEvent)
                                showSnackbar = true
                                snackbarText = "Participation successful!"
                                presentationMode.wrappedValue.dismiss()

                            },
                            secondaryButton: .cancel()
                        )
                    }
                    .padding()
                    
                }
                
               
             
            
            
        

            }
            .padding(16)
        }
        .overlay(
                   Toast(text: $snackbarText, isShowing: $showSnackbar)
                       .padding(.bottom, 100) // Adjust the position of the toast
               )
        .background(Color.white)
        .cornerRadius(8)
        .shadow(radius: 4)
        .padding(8)
        .navigationBarTitle("Event Details", displayMode: .inline)
        .onAppear{
            checkIfParticipated()
        }
           
        
       
    }
    
}
/*
struct Snackbar: View {
    @Binding var text: String
    @Binding var isShowing: Bool

    var body: some View {
        VStack {
            Spacer()
            HStack {
                Text(text)
                    .foregroundColor(.white)
                    .padding()
                    .background(Color.black)
                    .cornerRadius(8)
                    .onTapGesture {
                        isShowing = false
                    }
                Spacer()
            }
            .padding()
        }
        .animation(.easeInOut)
    }
}*/


struct MapSheetView: View {
    var eventLocation: String

    @State private var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 0, longitude: 0), // Default coordinates
        span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
    )

    var body: some View {
        VStack {
            Text("Event Location: \(eventLocation)")
                .font(.headline)
                .padding(.top, 10)

            Map(coordinateRegion: $region, showsUserLocation: true)
                .onAppear {
                    // Perform geocoding to get coordinates from the location name
                    let geocoder = CLGeocoder()
                    geocoder.geocodeAddressString(eventLocation) { placemarks, error in
                        if let placemark = placemarks?.first, let location = placemark.location {
                            // Update the region with the obtained coordinates
                            region.center = location.coordinate
                        }
                    }
                }
                .frame(height: 300)

            Spacer()
        }
        .padding()
        .navigationBarTitle("Map View")
    }
}



struct Toast: View {
    @Binding var text: String
    @Binding var isShowing: Bool

    var body: some View {
        VStack {
            Spacer()
            HStack {
                Text(text)
                    .foregroundColor(.white)
                    .padding()
                    .background(Color.black)
                    .cornerRadius(8)
                    .onTapGesture {
                        isShowing = false
                    }
            }
            .padding()
        }
        .animation(.easeInOut)
        .opacity(isShowing ? 1.0 : 0.0)
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                withAnimation {
                    isShowing = false
                }
            }
        }
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
