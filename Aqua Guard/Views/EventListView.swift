//
//  EventListView.swift
//  Aqua Guard
//
//  Created by Malek Labidi on 27/11/2023.
//

import SwiftUI

struct EventListView: View {
    @EnvironmentObject var viewModel: EventViewModel
    
    var body: some View {
        NavigationView {
            List {
                Section(header: Text("No Events").font(.title).foregroundColor(Color.darkBlue), footer: Text("")) {
                    Image("calendar_amico")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 250, height: 250)
                        .padding(.top, 5)
                    
                    Text("No Events exists")
                        .font(.system(size: 20))
                        .foregroundColor(Color.darkBlue)
                        .multilineTextAlignment(.center)
                        .padding(.top, 5)
                }
                
                ForEach(viewModel.events) { event in
                    EventCardView(event: event)
                        .listRowInsets(EdgeInsets(top: 4, leading: 4, bottom: 4, trailing: 4))
                }
            }
            .navigationBarTitle("Events", displayMode: .inline) // Fix the typo here
            .background(
                Image("background_splash_screen")
                    .resizable()
                    .scaledToFill()
                    .edgesIgnoringSafeArea(.all)
            )
        }
    }
}

struct EventListView_Previews: PreviewProvider {
    static var previews: some View {
        // Create an instance of EventViewModel
        let viewModel = EventViewModel()

        // Provide the viewModel as an environment object in the preview
        EventListView()
            .environmentObject(viewModel)
    }
}
