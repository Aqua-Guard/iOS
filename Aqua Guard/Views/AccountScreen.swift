//
//  AccountScreen.swift
//  Aqua Guard
//
//  Created by Amira Ben Mbarek on 27/12/2023.
//

import SwiftUI

struct AccountScreen: View {
    var screenWidth = UIScreen.main.bounds.width
    var screenHeight = UIScreen.main.bounds.height
    @State var isDarkModeEnabled: Bool = false
    @State var isActive: Bool = false
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>

    
    var body: some View {
        NavigationView {
            ZStack{
                LinearGradient(gradient: Gradient(colors: [isDarkModeEnabled ? Color.black : Color.white, isDarkModeEnabled ? Color.lightBlue : Color.lightBlue]), startPoint: .top, endPoint: .bottom)
                    .edgesIgnoringSafeArea(.all)
                
                VStack {
                    Spacer()
                    
                    VStack {
                        HStack {
                            Button(action: {
                                self.presentationMode.wrappedValue.dismiss()
                            }) {
                                Image(systemName: "arrow.left.circle.fill")
                                    .resizable()
                                    .foregroundColor(.blue)
                                    .frame(width: 25, height: 25)
                            }
                            
                            Spacer()
                        }
                    }
                    .alignmentGuide(.top) { _ in 0 }
                    .alignmentGuide(.leading) { _ in 0 }
                    .padding()
                            
                            
                        
                            let userImageURLString = "http://172.18.1.232:9090/images/user/\((LoginViewModell.defaults.string(forKey: "image") ?? ""))"
                            
                            GeometryReader { geometry in
                                AsyncImage(url: URL(string: userImageURLString)) { phase in
                                    switch phase {
                                    case .success(let image):
                                        image
                                            .resizable()
                                            .scaledToFit()
                                            .frame(width: geometry.size.width, height: geometry.size.height)
                                            .clipShape(Circle())
                                            .overlay(Circle().stroke(Color.white, lineWidth: 2))
                                    @unknown default:
                                        EmptyView()
                                    }
                                }
                            }
                            .frame(width: screenWidth * 0.6, height: screenWidth * 0.6)
                            .padding(.bottom, 22)

                            Text("Username:")
                                    .font(.headline)
                            Text(LoginViewModell.defaults.string(forKey: "username") ?? "")
                                    .font(.subheadline)
                                    .foregroundColor(.gray)
                                    .padding(.bottom, 12)
                            
                            Text("Email:")
                                    .font(.headline)
                            Text(LoginViewModell.defaults.string(forKey: "email") ?? "")
                                    .font(.subheadline)
                                    .foregroundColor(.gray)
                                    .padding(.bottom, 12)
                            
                            Text("First Name:")
                                    .font(.headline)
                            Text(LoginViewModell.defaults.string(forKey: "firstName") ?? "")
                                    .font(.subheadline)
                                    .foregroundColor(.gray)
                                    .padding(.bottom, 12)
                            
                            Text("Last Name:")
                                    .font(.headline)
                            Text(LoginViewModell.defaults.string(forKey: "lastName") ?? "")
                                    .font(.subheadline)
                                    .foregroundColor(.gray)
                                    .padding(.bottom, 12)
                            
                            Text("Role:")
                                    .font(.headline)
                            Text(LoginViewModell.defaults.string(forKey: "role") ?? "")
                                    .font(.subheadline)
                                    .foregroundColor(.gray)
                                    .padding(.bottom, 12)
                            
                            Text("Total points:")
                                    .font(.headline)
                            Text(LoginViewModell.defaults.string(forKey: "nbPts") ?? "")
                                    .font(.subheadline)
                                    .foregroundColor(.gray)
                                    .padding(.bottom, 12)

                            
                            
                        
                        
                        /*
                    ZStack {
                        NavigationLink(destination: EditProfile(), isActive: $isActive) {
                            
                        }
                            Button(action:{
                                isActive = true
                            })
                            {
                                Text("Edit Profile")
                                    .foregroundColor (.white)
                                    .fontWeight (.semibold)
                                    .font(.system(size:22))
                                    .frame(minWidth: 0, maxWidth: .infinity)
                                    .frame(width: screenWidth * 0.88, height: screenWidth * 0.13)
                            }
                    
                        }
                        .buttonStyle(.borderedProminent)
                        .buttonBorderShape(.roundedRectangle)
                        .tint(Color.blue)
                        .cornerRadius(30)
                        .padding(.horizontal)
                            */
                        
                        
                    }
            }
        }.navigationBarBackButtonHidden(true)
        .navigationBarColor(.darkBlue, textColor: UIColor.white)
    
        
        
        
}
}

#Preview {
    AccountScreen()
}
