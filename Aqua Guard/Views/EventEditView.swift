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
                               
                                       Image(uiImage: selectedImage ?? (URL(string: "http://192.168.43.253:9090/images/event/\(event.eventImage)")
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
                                           ImagePicker(didImagePicked: { image in
                                               self.selectedImage = image
                                           }, isImagePickerPresented: $isImagePickerPresented)
                                       }
                                   

                               TextField("Event Name", text: $eventName)
                                   .textFieldStyle(RoundedBorderTextFieldStyle())
                                   .padding(.top, 10)
                               
                               TextField("Event Description", text: $eventDescription)
                                   .textFieldStyle(RoundedBorderTextFieldStyle())
                                   .padding(.top, 10)
                               
                               VStack {
                                   TextField("Start Date", text: Binding(
                                       get: {
                                           let dateFormatter = DateFormatter()
                                           dateFormatter.dateFormat = "yyyy-MM-dd"
                                           return dateFormatter.string(from: startDate)
                                       },
                                       set: { newDateString in
                                           let dateFormatter = DateFormatter()
                                           dateFormatter.dateFormat = "yyyy-MM-dd"
                                           if let newDate = dateFormatter.date(from: newDateString) {
                                               startDate = newDate
                                           }
                                       }
                                   ))
                                   .textFieldStyle(RoundedBorderTextFieldStyle())
                                   .padding(.top, 10)

                                   Button(action: {
                                       // Show the DatePicker with confirmation
                                       isStartDatePickerPresented.toggle()
                                   }) {
                                       Text("Select Start Date")
                                   }
                                   .padding()

                                   // Present the DatePicker in a sheet
                                   if isStartDatePickerPresented {
                                       DatePickerSheet(selectedDate: $startDate, isPresented: $isStartDatePickerPresented)
                                   }
                               }

                               VStack {
                                   TextField("End Date", text: Binding(
                                       get: {
                                           let dateFormatter = DateFormatter()
                                           dateFormatter.dateFormat = "yyyy-MM-dd"
                                           return dateFormatter.string(from: endDate)
                                       },
                                       set: { newDateString in
                                           let dateFormatter = DateFormatter()
                                           dateFormatter.dateFormat = "yyyy-MM-dd"
                                           if let newDate = dateFormatter.date(from: newDateString) {
                                               endDate = newDate
                                           }
                                       }
                                   ))
                                   .textFieldStyle(RoundedBorderTextFieldStyle())
                                   .padding(.top, 10)

                                   Button(action: {
                                       // Show the DatePicker with confirmation
                                       isEndDatePickerPresented.toggle()
                                   }) {
                                       Text("Select End Date")
                                   }
                                   .padding()

                                   // Present the DatePicker in a sheet
                                   if isEndDatePickerPresented {
                                       DatePickerSheet(selectedDate: $endDate, isPresented: $isEndDatePickerPresented)
                                   }
                               }

                               
                               TextField("Event Location", text: $eventLocation)
                                   .textFieldStyle(RoundedBorderTextFieldStyle())
                                   .padding(.top, 10)
                               
                               Text(errorMessage)
                                   .foregroundColor(.red)
                                   .padding(.top, 10)
                                   .hidden() // You may need to handle the visibility based on your logic.
                               
                               Button(action: {
                                   // Action for submitting event
                                   print("Submit Event")
                                   if let imageData = selectedImage?.jpegData(compressionQuality: 0.8) {
                                       
                                       print("Base64 representation of UIImage: \(imageData)")
                                       viewModel.updateEvent(eventId: event.idEvent,  eventName: eventName, description: eventDescription, eventImage: imageData, dateDebut: startDate, dateFin: endDate, lieu: eventLocation)
                                   } else {
                                       print("Failed to convert UIImage to data")
                                   }
                                   // Show alert
                                               alertMessage = "Event Updated successfully !"
                                               showAlert = true
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
