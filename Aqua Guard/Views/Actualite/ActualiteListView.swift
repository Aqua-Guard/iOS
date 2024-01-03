//
//  ActualiteListView.swift
//  Aqua Guard
//
//  Created by adem on 1/12/2023.
//

import SwiftUI

struct ActualiteListView: View {
    @EnvironmentObject var viewModel: ActualiteViewModel
    @State private var searchText = ""

    var body: some View {
        
        VStack {
            
            Spacer()
            
            NavigationView {
                
                VStack {
                    HStack {
                        TextField("Search", text: $searchText){ isEditing in
                            
                        } onCommit: {
                            print("---------fama7aja houni")
                            viewModel.searchActualites(about: searchText)
                        }
                        .padding(8)
                        .background(Color(.systemGray6))
                        .cornerRadius(8)
                        .padding(.trailing, 8)
                        
                        Button(action: {
                                print("Search button clicked with text: \(searchText)")
                                viewModel.searchActualites(about: searchText)
                            }) {
                                Image(systemName: "magnifyingglass")
                                    .foregroundColor(.gray)
                            }
                    }
                    .padding(8)
                    .background(Color(.systemGray6))
                    .cornerRadius(10)
                    .padding(8)
                    
                    List {if viewModel.actualites.isEmpty {
                        Section(header: Text("No actualites").font(.title).foregroundColor(Color.darkBlue), footer: Text("")) {
                            Image("photo")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 250, height: 250)
                                .padding(.top, 5)
                            
                            Text("No Actualite exists")
                                .font(.system(size: 20))
                                .foregroundColor(Color.darkBlue)
                                .multilineTextAlignment(.center)
                                .padding(.top, 5)
                        }
                    } else {
                        
                        ForEach(viewModel.actualites) { actualite in
                            ActualiteCardView(actualite: actualite)
                                .listRowInsets(EdgeInsets(top: 4, leading: 4, bottom: 4, trailing: 4))
                        }
                    }
                    }
                    
                }.background(Image("background_splash_screen"))
            }.onAppear {
                viewModel.fetchActualite()
            }
        }               .padding(8)
            .listStyle(PlainListStyle())
            
            .background(Image("background_splash_screen")
                .resizable()
                .scaledToFill()
                .edgesIgnoringSafeArea(.all))
            .navigationTitle("Actualites").navigationBarTitleDisplayMode(.inline)
            .navigationBarBackButtonHidden(true)
    } }
struct ActualiteListView_Previews: PreviewProvider {
    static var previews: some View {
        // Create an instance of EventViewModel
        let viewModel = EventViewModel()

        // Provide the viewModel as an environment object in the preview
        ActualiteListView()
            .environmentObject(viewModel)
    }
}

