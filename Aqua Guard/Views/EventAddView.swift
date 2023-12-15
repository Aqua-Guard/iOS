//
//  EventAddView.swift
//  Aqua Guard
//
//  Created by Malek Labidi on 29/11/2023.
//

import SwiftUI
import UIKit
import MapKit

struct ImagePickerEvent: UIViewControllerRepresentable {
    class Coordinator: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
        var parent: ImagePickerEvent
        var didImagePicked: (UIImage) -> Void
        
        @State private var region = MKCoordinateRegion(
            center: CLLocationCoordinate2D(latitude: 37.7749, longitude: -122.4194),
            span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
        )

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
    @State private var isSnackbarShowing = false
    @State private var snackbarMessage = ""
    @StateObject var viewModel: MyEventViewModel
    @State private var eventName = ""
       @State private var eventDescription = ""
    @State private var startDate = Date()
     @State private var endDate = Date()
       @State private var eventLocation = ""
       @State private var errorMessage = ""
    
    @State private var isStartDatePickerPresented = false
    @State private var isEndDatePickerPresented = false
    
    @State private var selectedImage: UIImage?
    @State private var mapRegion = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 36.8065, longitude: 10.1815), // Tunis coordinates
        span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
    )
    @State private var selectedCoordinate: CLLocationCoordinate2D?

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

                                 
                       
                            Text("Event Name")
                                  .font(.headline)
                            TextField("Event Name", text: $eventName)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                                .padding(.top, 10)
                            Text("Description")
                                  .font(.headline)
                            TextEditor(text: $eventDescription)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                                           .frame(height: 100) // Set the desired height
                                           .border(Color.gray, width: 1) // Optional: Add a border for visual separation
                                           .padding(.top, 10)
                                        
                            
                            VStack(alignment: .leading, spacing: 10) {
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
                            
                            CustomMapView(
                                region: $mapRegion,
                                coordinate: $selectedCoordinate,
                                onCoordinateChanged: { newCoordinate in
                                    selectedCoordinate = newCoordinate

                                    // Perform reverse geocoding to get the address from the selectedCoordinate
                                    if let latitude = selectedCoordinate?.latitude, let longitude = selectedCoordinate?.longitude {
                                        let location = CLLocation(latitude: latitude, longitude: longitude)
                                        let geocoder = CLGeocoder()
                                        geocoder.reverseGeocodeLocation(location) { placemarks, error in
                                            if let placemark = placemarks?.first {
                                                eventLocation = "\(placemark.thoroughfare ?? "") \(placemark.subThoroughfare ?? ""), \(placemark.locality ?? "")"
                                            }
                                        }
                                    }
                                },
                                onZoomIn: {
                                    // Handle zoom in action
                                    print("Zoom In")
                                },
                                onZoomOut: {
                                    // Handle zoom out action
                                    print("Zoom Out")
                                }
                            )
                            .frame(height: 200)
                            .cornerRadius(10)
                            .padding()

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
                                            try await viewModel.createEvent(eventName: eventName, description: eventDescription, eventImage: imageData, dateDebut: startDate, dateFin: endDate, lieu: eventLocation)

                                            // Show alert
                                            alertMessage = "Event added successfully"
                                            showAlert = true
                                        } else {
                                            print("Failed to convert UIImage to data")
                                        }
                                    } catch {
                                        print("Error adding event: \(error)")
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

    private func showSnackbar(message: String) {
        snackbarMessage = message
        withAnimation {
            isSnackbarShowing = true
        }
    }
}

struct SnackbarView: View {
    var message: String
    @Binding var isShowing: Bool

    var body: some View {
        VStack {
            Spacer()

            Text(message)
                .foregroundColor(.white)
                .padding()
                .background(Color.red)
                .cornerRadius(8)
                .onTapGesture {
                    withAnimation {
                        isShowing = false
                    }
                }
                .padding(.bottom, 16)
                .padding(.horizontal, 16)
                .opacity(isShowing ? 1 : 0)
                .offset(y: isShowing ? 0 : 100)
        }
    }
}
struct CustomMapView: UIViewRepresentable {
    @Binding var region: MKCoordinateRegion
    @Binding var coordinate: CLLocationCoordinate2D?
    var onCoordinateChanged: (CLLocationCoordinate2D) -> Void
    var onZoomIn: (() -> Void)?
    var onZoomOut: (() -> Void)?

    func makeUIView(context: Context) -> MKMapView {
        let mapView = MKMapView()
        mapView.delegate = context.coordinator
        return mapView
    }

    func updateUIView(_ uiView: MKMapView, context: Context) {
        uiView.setRegion(region, animated: true)

        let annotation = MKPointAnnotation()
        annotation.coordinate = coordinate ?? CLLocationCoordinate2D(latitude: 0, longitude: 0)

        uiView.removeAnnotations(uiView.annotations)
        uiView.addAnnotation(annotation)
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    class Coordinator: NSObject, MKMapViewDelegate {
        var parent: CustomMapView

        init(_ parent: CustomMapView) {
            self.parent = parent
        }

        func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
            parent.region = mapView.region
            parent.coordinate = mapView.centerCoordinate
            parent.onCoordinateChanged(mapView.centerCoordinate)
        }

        // Function to zoom in
        func zoomIn() {
            parent.onZoomIn?()
        }

        // Function to zoom out
        func zoomOut() {
            parent.onZoomOut?()
        }
    }
}






 
/*
#Preview {
    EventAddView()
}
*/
