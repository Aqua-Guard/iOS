//
//  MyEvents.swift
//  Aqua Guard
//
//  Created by Malek Labidi on 28/11/2023.
//

import SwiftUI

struct MyEvents: View {
    @EnvironmentObject var viewModel: MyEventViewModel
    @State private var showAlert = false
    @State private var eventToDelete: Event? = nil
    @State private var showToast = false

    var body: some View {
        NavigationView{
             
            List{
                
                Section(header: Text("No Events").font(.title).foregroundColor(Color.darkBlue), footer: Text("")) {
                    
                    Image("calendar_amico")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 250, height: 250)
                        .padding(.all, 5)
                    
                    
                    Text("No Events exists")
                        .font(.system(size: 20))
                        .foregroundColor(Color.darkBlue)
                        .multilineTextAlignment(.center)
                        .padding(.top, 5)
                }
                
                
                ForEach(viewModel.events) { event in
                    EventCardView(event: event)
                        .listRowInsets(EdgeInsets(top: 4, leading: 4, bottom: 4, trailing: 4))
                        .swipeActions(edge: .leading) {
                            NavigationLink(destination: EventEditView()) {
                                  Label("Edit", systemImage: "pencil")
                              }
                              .tint(.blue)
                        
                        }
                        .swipeActions(edge: .trailing){
                            Button(action: {
                              eventToDelete = event
                                showAlert = true
                            }) {
                                Label("Delete", systemImage: "trash")
                            }
                            .tint(.red)
                        }
                }
                
            
            
            }
                .navigationBarTitle("My Events").navigationBarTitleDisplayMode(.inline)
                .navigationBarItems(trailing:
                                NavigationLink(destination: EventAddView()) {
                                    Image(systemName: "plus.circle")
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 24, height: 24)
                })
                .alert(isPresented: $showAlert) {
                    Alert(
                                      title: Text("Confirm Deletion"),
                                      message: Text("Are you sure you want to delete this event?"),
                                      primaryButton: .destructive(
                                          Text("Delete"),
                                          action: {
                                                  viewModel.deleteEvent(eventID: eventToDelete!.idEvent)
                                              showToast = true
                                              
                                          }
                                      ),
                                      secondaryButton: .cancel()
                            
                    )
                          }
                .overlay(
                              VStack {
                                  if showToast {
                                      Text("Event deleted successfully!")
                                          .foregroundColor(.white)
                                          .padding()
                                          .background(Color.black.opacity(0.7))
                                          .cornerRadius(10)
                                          .transition(.opacity)
                                          .onAppear {
                                              DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                                                  withAnimation {
                                                      showToast = false
                                                  }
                                              }
                                          }
                                  }
                              }
                              .padding(.bottom, 80)
                              , alignment: .bottom
                          )
        }
    }
}

struct MyEvents_Previews: PreviewProvider {
    static var previews: some View {
        // Create an instance of EventViewModel
        let viewModel = MyEventViewModel()

        MyEvents()
            .environmentObject(viewModel)
    }
}
