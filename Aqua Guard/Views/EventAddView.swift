//
//  EventAddView.swift
//  Aqua Guard
//
//  Created by Malek Labidi on 29/11/2023.
//

import SwiftUI

struct EventAddView: View {
    @State private var eventName = ""
       @State private var eventDescription = ""
       @State private var startDate = ""
       @State private var endDate = ""
       @State private var eventLocation = ""
       @State private var errorMessage = ""
    var body: some View {
        NavigationView {
            ZStack {
               
                
                VStack {
                  Spacer()
                    
                    ScrollView {
                        VStack(alignment: .leading, spacing: 10) {
                            Image(systemName: "photo")
                                .resizable()
                                .frame(width: 150, height: 150)
                                .foregroundColor(.darkBlue)
                            
                            Button(action: {
                                // Action for updating event image
                                print("Add Event Image")
                            }) {
                                Label("Add Event image", systemImage: "photo.on.rectangle")
                                    .foregroundColor(.darkBlue)
                            }
                            
                            TextField("Event Name", text: $eventName)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                                .padding(.top, 10)
                            
                            TextField("Event Description", text: $eventDescription)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                                .padding(.top, 10)
                            
                            TextField("Start Date", text: $startDate)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                                .padding(.top, 10)
                                .disabled(true) // You may need to implement a date picker.
                            
                            TextField("End Date", text: $endDate)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                                .padding(.top, 10)
                                .disabled(true) // You may need to implement a date picker.
                            
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
                            }) {
                                Text("Submit")
                                    .frame(maxWidth: .infinity)
                                    .padding()
                                    .background(Color.blue)
                                    .foregroundColor(.white)
                                    .cornerRadius(10)
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

#Preview {
    EventAddView()
}

