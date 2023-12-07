//
//  EventAddView.swift
//  Aqua Guard
//
//  Created by Malek Labidi on 29/11/2023.
//

import SwiftUI
import UIKit

struct ImagePickerEvent: UIViewControllerRepresentable {
    class Coordinator: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
        var parent: ImagePickerEvent
        var didImagePicked: (UIImage) -> Void

        init(parent: ImagePickerEvent, didImagePicked: @escaping (UIImage) -> Void) {
            self.parent = parent
            self.didImagePicked = didImagePicked
        }

        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
            if let uiImage = info[.originalImage] as? UIImage {
                didImagePicked(uiImage)
            }

            parent.isImagePickerPresented = false
        }

        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            parent.isImagePickerPresented = false
        }
    }

    var didImagePicked: (UIImage) -> Void
    @Binding var isImagePickerPresented: Bool

    init(didImagePicked: @escaping (UIImage) -> Void, isImagePickerPresented: Binding<Bool>) {
        self.didImagePicked = didImagePicked
        self._isImagePickerPresented = isImagePickerPresented
    }

    func makeCoordinator() -> Coordinator {
        return Coordinator(parent: self, didImagePicked: didImagePicked)
    }

    func makeUIViewController(context: Context) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.delegate = context.coordinator
        picker.sourceType = .photoLibrary
        return picker
    }

    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {}
}


struct EventAddView: View {
    @EnvironmentObject var viewModel: MyEventViewModel
    @State private var eventName = ""
       @State private var eventDescription = ""
    @State private var startDate = Date()
     @State private var endDate = Date()
       @State private var eventLocation = ""
       @State private var errorMessage = ""
    @State private var selectedImage: UIImage?

    @State private var isImagePickerPresented: Bool = false

    @Environment(\.presentationMode) var presentationMode
    @State private var isDatePickerPresented = false
    
    @State private var showAlert = false
     @State private var alertMessage = ""
    var body: some View {
        NavigationView {
            ZStack {
               
                
                VStack {
                  Spacer()
                    
                    ScrollView {
                        VStack(alignment: .leading, spacing: 10) {
                            Image(uiImage: selectedImage ?? UIImage(systemName: "photo")!)
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

                                 
                       
                            
                            TextField("Event Name", text: $eventName)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                                .padding(.top, 10)
                            
                            TextField("Event Description", text: $eventDescription)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                                .padding(.top, 10)
                            
                            VStack {
                                        TextField("Start Date", text: Binding(
                                            get: {
                                                // Convert the Date to String with the desired format
                                                let dateFormatter = DateFormatter()
                                                dateFormatter.dateFormat = "yyyy-MM-dd"
                                                return dateFormatter.string(from: startDate)
                                            },
                                            set: { newDateString in
                                                // Convert the String to Date with the desired format
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
                                            isDatePickerPresented.toggle()
                                        }) {
                                            Text("Select Start Date")
                                        }
                                        .padding()

                                        // Present the DatePicker in a sheet
                                        if isDatePickerPresented {
                                            DatePickerSheet(selectedDate: $startDate, isPresented: $isDatePickerPresented)
                                        }
                                    }
                            VStack {
                                        TextField("End Date", text: Binding(
                                            get: {
                                                // Convert the Date to String with the desired format
                                                let dateFormatter = DateFormatter()
                                                dateFormatter.dateFormat = "yyyy-MM-dd"
                                                return dateFormatter.string(from: endDate)
                                            },
                                            set: { newDateString in
                                                // Convert the String to Date with the desired format
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
                                            isDatePickerPresented.toggle()
                                        }) {
                                            Text("Select End Date")
                                        }
                                        .padding()

                                        // Present the DatePicker in a sheet
                                        if isDatePickerPresented {
                                            DatePickerSheet(selectedDate: $endDate, isPresented: $isDatePickerPresented)
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
                                // Assuming uiImage is your UIImage
                                if let imageData = selectedImage?.jpegData(compressionQuality: 0.8) {
                                    
                                    print("Base64 representation of UIImage: \(imageData)")
                                    viewModel.createEvent( eventName: eventName, description: eventDescription, eventImage: imageData, dateDebut: startDate, dateFin: endDate, lieu: eventLocation)
                                } else {
                                    print("Failed to convert UIImage to data")
                                }

                               
                                // Show alert
                                            alertMessage = "Event added successfully"
                                            showAlert = true
                              
                            }) {
                                Text("Submit")
                                    .frame(maxWidth: .infinity)
                                    .padding()
                                    .background(Color.blue)
                                    .foregroundColor(.white)
                                    .cornerRadius(10)
                            }   .alert(isPresented: $showAlert) {
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
                    .navigationBarTitle("Add Event", displayMode: .inline)
                }
                .background(Image("background_splash_screen")
                                         .resizable()
                                         .scaledToFill()
                                         .edgesIgnoringSafeArea(.all))
                
            }
        }
    }

}




 
/*
#Preview {
    EventAddView()
}
*/
