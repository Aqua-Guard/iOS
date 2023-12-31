//
//  EventEditView.swift
//  Aqua Guard
//
//  Created by Malek Labidi on 29/11/2023.
//

import SwiftUI

struct EventEditView: View {
    @EnvironmentObject var viewModel: MyEventViewModel
    let event: Event
    @State private var eventName: String
        @State private var eventDescription: String
        @State private var startDate: Date
        @State private var endDate: Date
    @State private var eventImage: String
        @State private var eventLocation: String
        @State private var errorMessage: String
    
    @State private var isStartDatePickerPresented = false
    @State private var isEndDatePickerPresented = false
    
    @Environment(\.presentationMode) var presentationMode
    
    @State private var showAlert = false
     @State private var alertMessage = ""
    @State private var isImagePickerPresented: Bool = false

    @State private var selectedImage: UIImage?
    @State private var isSnackbarShowing = false
    @State private var snackbarMessage = ""

        init(event: Event) {
            self.event = event
            
            // Set up initial state based on the provided event
            _eventName = State(initialValue: event.eventName)
            _eventDescription = State(initialValue: event.description)
            _startDate = State(initialValue: event.dateDebut)
            _endDate = State(initialValue: event.dateFin)
            _eventImage = State(initialValue: event.eventImage)
            _eventLocation = State(initialValue: event.lieu)
            _errorMessage = State(initialValue: "")
        }
       
       var body: some View {
           NavigationView {
                   VStack {
                     Spacer()
                       
                       ScrollView {
                           VStack(alignment: .leading, spacing: 10) {
                               
                                       Image(uiImage: selectedImage ?? (URL(string: "https://aquaguard-tux1.onrender.com/images/event/\(event.eventImage)")
                                                                   .flatMap { try? Data(contentsOf: $0) }
                                                                   .flatMap { UIImage(data: $0) }
                                                                   ?? UIImage(systemName: "photo"))!)
                                           .resizable()
                                           .frame(width: 150, height: 150)
                                           .foregroundColor(.darkBlue)

                                       Button(action: {
                                           // Action for updating event image
                                           self.isImagePickerPresented.toggle() // Toggle the boolean state to open/close the image picker
                                       }) {
                                           Label("Add Event image", systemImage: "photo.on.rectangle")
                                               .foregroundColor(.darkBlue)
                                       }
                                       .sheet(isPresented: $isImagePickerPresented) {
                                           ImagePickerEvent(didImagePicked: { image in
                                               self.selectedImage = image
                                           }, isImagePickerPresented: $isImagePickerPresented)
                                       }
                                   

                               Text("Event Name")
                                       .font(.headline)
                               TextField("Event Name", text: $eventName)
                                   .textFieldStyle(RoundedBorderTextFieldStyle())
                                   .padding(.top, 10)
                               Text("Description")
                                       .font(.headline)
                               TextEditor(text: $eventDescription)
                                              .frame(height: 100) // Set the desired height
                                              .border(Color.gray, width: 1) // Optional: Add a border for visual separation
                                              .padding(.top, 10)
                               
                               VStack  (alignment: .leading, spacing: 10){
                                   Text("Start Date")
                                       .font(.headline)

                                   DatePicker("Select Start Date", selection: $startDate, displayedComponents: [.date])
                                       .labelsHidden()
                                       .textFieldStyle(RoundedBorderTextFieldStyle())
                                       .padding(.top, 10)
                                       .accentColor(.darkBlue)
                               }

                               VStack (alignment: .leading, spacing: 10){
                                   Text("End Date")
                                       .font(.headline)

                                   DatePicker("Select End Date", selection: $endDate, displayedComponents: [.date])
                                       .labelsHidden()
                                       .textFieldStyle(RoundedBorderTextFieldStyle())
                                       .padding(.top, 10)
                                       .accentColor(.darkBlue)
                               }

                               Text("Location")
                                       .font(.headline)
                               TextField("Event Location", text: $eventLocation)
                                   .textFieldStyle(RoundedBorderTextFieldStyle())
                                   .padding(.top, 10)
                               
                              /* Text(errorMessage)
                                   .foregroundColor(.red)
                                   .padding(.top, 10)
                                   .hidden() // You may need to handle the visibility based on your logic.*/
                               
                               SnackbarView(message: snackbarMessage, isShowing: $isSnackbarShowing)
                                     .onChange(of: isSnackbarShowing) { newValue in
                                         if newValue {
                                             DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                                                 withAnimation {
                                                     isSnackbarShowing = false
                                                 }
                                             }
                                         }
                                     }
                               
                               Button(action: {
                                   // Action for submitting event
                                   print("Submit Event")
                                   
                                   guard Date() < startDate else {
                                           errorMessage = "Start date should be after today date"
                                           showSnackbar(message: errorMessage)
                                           return
                                       }
                                   guard startDate < endDate else {
                                           errorMessage = "End date should be after start date"
                                           showSnackbar(message: errorMessage)
                                           return
                                       }

                                       // Validate description
                                       guard eventDescription.count >= 10 && eventDescription.count <= 500 else {
                                           errorMessage = "Event description should be between 10 and 500 characters"
                                           showSnackbar(message: errorMessage)
                                           return
                                       }
                                   // Validate name
                                   guard eventName.count >= 3 && eventName.count <= 30 else {
                                       errorMessage = "Event name should be between 3 and 30 characters"
                                       showSnackbar(message: errorMessage)
                                       return
                                   }
                                   // Validate lieu
                                   guard eventLocation.count >= 3 && eventLocation.count <= 50 else {
                                       errorMessage = "Event location should be between 3 and 50 characters"
                                       showSnackbar(message: errorMessage)
                                       return
                                   }

                                   Task {
                                       do {
                                           // Assuming uiImage is your UIImage
                                           if let imageData = selectedImage?.jpegData(compressionQuality: 0.8) {
                                               print("Base64 representation of UIImage: \(imageData)")
                                               try await viewModel.updateEvent(
                                                   eventId: event.idEvent,
                                                   eventName: eventName,
                                                   description: eventDescription,
                                                   eventImage: imageData,
                                                   dateDebut: startDate,
                                                   dateFin: endDate,
                                                   lieu: eventLocation
                                               )

                                               // Show alert
                                               alertMessage = "Event Updated successfully!"
                                               showAlert = true
                                           } else {
                                               print("Failed to convert UIImage to data")
                                           }
                                       } catch {
                                           print("Error updating event: \(error)")
                                           // Handle error if needed
                                       }
                                   }
                               }) {
                                   Text("Submit")
                                       .frame(maxWidth: .infinity)
                                       .padding()
                                       .background(Color.blue)
                                       .foregroundColor(.white)
                                       .cornerRadius(10)
                               }
                               .alert(isPresented: $showAlert) {
                                 Alert(
                                     title: Text("Success"),
                                     message: Text(alertMessage),
                                     dismissButton: .default(Text("OK")) {
                                         // Dismiss the current view
                                         presentationMode.wrappedValue.dismiss()
                                     }
                                 )
                             }
                               .padding(.top, 20)
                           }
                           .padding(20)
                           .background(Color.white)
                           .cornerRadius(20)
                           .padding([.leading, .trailing], 10)
                       }
                       .navigationBarTitle("Update Event", displayMode: .inline)
                   }
                   .background(Image("background_splash_screen")
                                            .resizable()
                                            .scaledToFill()
                                            .edgesIgnoringSafeArea(.all))
               }
           }
    private func showSnackbar(message: String) {
        snackbarMessage = message
        withAnimation {
            isSnackbarShowing = true
        }
    }
       
}


struct DatePickerSheet: View {
    @Binding var selectedDate: Date
    @Binding var isPresented: Bool

    var body: some View {
        VStack {
            DatePicker("Select End Date", selection: $selectedDate, in: Date()..., displayedComponents: .date)
                .datePickerStyle(WheelDatePickerStyle())
                .padding()

            Button(action: {
                // Dismiss the sheet when the user taps Done
                isPresented.toggle()
            }) {
                Text("Done")
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
        }
        .padding()
    }
}
/*
struct EventEditView_Previews: PreviewProvider {
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

        return EventEditView(event: sampleEvent)
          
        
    }
}*/
