//
//  SettingsView.swift
//  Aqua Guard
//
//  Created by Amira Ben Mbarek on 12/8/23.
//

import SwiftUI

struct SettingsView: View {
    var screenWidth = UIScreen.main.bounds.width
    var screenHeight = UIScreen.main.bounds.height
    @State var isDarkModeEnabled: Bool = false
    @State var emailNotif: Bool = false
    @State private var deleteAlert = false
    let userImage = LoginViewModell.defaults.string(forKey: "image")
    @StateObject var viewModel: UserViewModel = UserViewModel()

    var body: some View {
        NavigationView {
            LinearGradient(gradient: Gradient(colors: [isDarkModeEnabled ? Color.black : Color.white, isDarkModeEnabled ? Color.lightBlue : Color.lightBlue]), startPoint: .top, endPoint: .bottom)
                    .edgesIgnoringSafeArea(.all)
                    .overlay{
                        List {
                            Section(header: ZStack{
                                Image("nav_header")
                                    .resizable()
                                    .scaledToFill()
                                    .frame(height: 200)
                                    .offset(y: -90)
                                VStack {
                                    if let unwrappedUserImage = userImage {
                                        let userImageURLString = "https://aquaguard-tux1.onrender.com/images/user/\(unwrappedUserImage)"
                                        
                                        AsyncImage(url: URL(string: userImageURLString))
                                            .scaledToFit()
                                            .frame(width: 100, height: 100)
                                            .clipShape(Circle())
                                            .overlay(Circle().stroke(Color.white, lineWidth: 2))
                                    }
                                    
                                    Text(LoginViewModell.defaults.string(forKey: "username") ?? "username")
                                        .font(.title)
                                        .fontWeight(.heavy)
                                        .foregroundColor(.white)
                                    Text(LoginViewModell.defaults.string(forKey: "email") ?? "email")
                                        .font(.title3)
                                        .fontWeight(.light)
                                        .foregroundColor(.white)
                                }
                                .offset(y: -screenWidth * 0.1)
                            }
                                .frame(height: screenWidth * 0.6)
                                .listRowInsets(EdgeInsets())) {
                                    EmptyView()
                                }
                                                            
                                HStack {
                                    Image(systemName: "person")
                                        .foregroundColor(.blue)
                                        .frame(width: screenWidth * 0.15, alignment: .center)
                                        .font(.system(size: 20))
                                    Text("Edit Profile")
                                        .foregroundColor(.blue)
                                        .font(.system(size: 20))
                                }
                                .listRowBackground(Color.white.opacity(0))
                                
                            NavigationLink(destination: changePassword()) {

                                HStack {
                                    Image(systemName: "lock")
                                        .foregroundColor(.blue)
                                        .font(.system(size: 20))
                                        .frame(width: screenWidth * 0.15, alignment: .center)
                                    Text("Change password")
                                        .font(.system(size: 20))
                                        .foregroundColor(.blue)
                                }
                                }
                                .listRowBackground(Color.white.opacity(0))
                                
                                HStack {
                                    Image(systemName: "")
                                        .frame(width: screenWidth * 0.15, alignment: .center)
                                    Text("Dark Mode")
                                        .foregroundColor(.blue)
                                        .font(.system(size: 20))
                                    Spacer()
                                    
                                    Toggle("", isOn: $isDarkModeEnabled)
                                        .labelsHidden()
                                        .foregroundColor(.blue)
                                }
                                .listRowBackground(Color.white.opacity(0))

                                HStack {
                                    Image(systemName: "")
                                        .frame(width: screenWidth * 0.15, alignment: .center)
                                    Text("Get notified by email")
                                        .font(.system(size: 20))
                                        .foregroundColor(.blue)
                                    Spacer()
                                    
                                    Toggle("", isOn: $emailNotif)
                                        .labelsHidden()
                                        .foregroundColor(.blue)
                                }
                                .listRowBackground(Color.white.opacity(0))

                            
                            HStack {
                                Image(systemName: "trash")
                                    .foregroundColor(.red)
                                    .font(.system(size: 20))
                                    .frame(width: screenWidth * 0.15, alignment: .center)
                                
                                Button(action: {
                                    deleteAlert = true
                                }, label: {
                                    Text("Delete account")
                                        .font(.system(size: 20))
                                        .foregroundColor(.red)
                                    
                                })
                                .alert(isPresented: $deleteAlert) {
                                    Alert(
                                        title: Text("Confirm Deletion"),
                                        message: Text("Are you sure you want to delete your account"),
                                        primaryButton: .destructive(Text("Confirm")) {
                                            Task {
                                                await self.viewModel.deleteAccount(id: LoginViewModell.defaults.string(forKey: "id")!)
                                                print("amira")
                                                
                                                viewModel.isDeleted = true
                                            }
                                        },
                                        secondaryButton: .cancel()
                                    )
                                }
                            }
                            .listRowBackground(Color.white.opacity(0))
                            .background(
                                NavigationLink("", destination: LoginView(), isActive: $viewModel.isDeleted)
                                    .hidden()
                                    .onReceive(viewModel.$isDeleted, perform: { _ in
                                        // Do nothing here, just receive the update
                                    })
                            )
                            
                            

                            
                            
                        }
                        
                    }
            .listStyle(PlainListStyle())
        }.accentColor(.white)
        
        .navigationBarColor(.darkBlue, textColor: UIColor.white)
        
        
        
        
    }
}

#Preview {
    SettingsView()
}
