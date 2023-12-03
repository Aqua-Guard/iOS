//
//  Drawer.swift
//  Aqua Guard
//
//  Created by Youssef Farhat on 28/11/2023.
//

import SwiftUI

struct Drawer: View {
    @EnvironmentObject var menuData:DrawerMenuViewModel
    
    var animation : Namespace.ID
    var body: some View {
        
        VStack{
            ZStack {
                // Background image
                Image("nav_header")
                    .resizable()
                    .scaledToFill()
                    .frame(width: 260, height: 200) // Set the width to match the drawer width
                    .edgesIgnoringSafeArea(.all) // Modified to fill the entire top area
                
                VStack {
                    
                    // Profile image, moved up to overlap with the background
                    Image("youssef")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 65, height: 65)
                        .clipShape(Circle())
                        .overlay(Circle().stroke(Color.white, lineWidth: 2))
                        .offset(y: -40) // Modified to adjust the position of the image
                    
                    // Name label, moved up closer to the profile image
                    Text("Youssef Farhat")
                        .fontWeight(.heavy)
                        .foregroundColor(.white)
                        .offset(y: -40) // Modified to adjust the position of the label
                    Text("Youssef.farhat@esprit. tn")
                        .fontWeight(.light)
                        .foregroundColor(.white)
                        .offset(y: -40) // Modified to adjust the position of the label
                }
                .frame(width: 260, height: 200)
                
                
                // Moved here to position the close button independently
                HStack {
                    Spacer()
                    // Close Button
                    if menuData.showDrawer {
                        DrawerCloseButton(animation: animation)
                            .padding(.trailing)
                            .offset(y: -70)
                    }
                    
                }
            }
            
            
            
            //.foregroundColor(.white)
            //.frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/,alignment: .leading)
            //.padding(.horizontal)
            //.padding(.top,1)
            // menue button
            VStack(spacing: 5){
                DrawerMenuButton(name:"My Calendar",image: "calendar",selectedMenu: $menuData.selectedMenu,animation: animation)
                
                DrawerMenuButton(name:"Notification",image: "bell.fill",selectedMenu: $menuData.selectedMenu,animation: animation)
                DrawerMenuButton(name:"MyEvents",image: "calendar.badge.clock",selectedMenu: $menuData.selectedMenu,animation: animation)
                DrawerMenuButton(name:"MyPosts",image: "rectangle.3.group.bubble",selectedMenu: $menuData.selectedMenu,animation: animation)
                DrawerMenuButton(name:"Reclamation",image: "exclamationmark.triangle.fill",selectedMenu: $menuData.selectedMenu,animation: animation)
            }
            .padding(.leading)
            .frame(width: 260,alignment: .leading)
            
            
            Divider()
                .frame(height: 2)
                .background(Color.darkBlue)
                .padding(.top,30)
                .padding(.horizontal,25)
            Spacer()
            DrawerMenuButton(name:"Logout",image: "rectangle.portrait.and.arrow.forward",selectedMenu: .constant(""),animation: animation)
                .padding(.bottom)
        }
        .frame(width: 260)
        .background(
            Color.white
                .ignoresSafeArea(.all,edges: .vertical))
        VStack(){
            TabView {
                
                Text("Home")
                    .tabItem {
                        Label("Home", systemImage: "house")
                    }
                Text("event")
                    .tabItem {
                        Label("Events", systemImage: "calendar")
                    }
                
                Text("post")
                    .tabItem {
                        Label("Forum", systemImage: "text.bubble.fill")
                    }
                
                Text("Store")
                    .tabItem {
                        Label("Store", systemImage: "bag")
                    }
                
                
            }
            .accentColor(.darkBlue)
            
        }
    }
        
}

#Preview {
    Home()
    
}
// Close button
struct DrawerCloseButton :View {
    @EnvironmentObject var menuData: DrawerMenuViewModel
    var animation : Namespace.ID
    var body: some View {
        Button(action: {
            withAnimation(.easeInOut){
                menuData.showDrawer.toggle()
            }
        }, label: {
            VStack(spacing: 5){
                Capsule()
                    .fill(menuData.showDrawer ? Color.white : Color.darkBlue)
                    .frame(width: 35,height: 3)
                    .rotationEffect(.init(degrees: menuData.showDrawer ? -50 : 0))
                // nraka7 fel X
                // ntala fiha bethabet 9Adech lezem bech terka7
                    .offset(x:menuData.showDrawer ? 2 : 0 , y: menuData.showDrawer ? 9 : 0)
                VStack(spacing: 5){
                    Capsule()
                        .fill(menuData.showDrawer ? Color.white : Color.darkBlue)
                        .frame(width: 35,height: 3)
                    Capsule()
                        .fill(menuData.showDrawer ? Color.white : Color.darkBlue)
                        .frame(width: 35,height: 3)
                    // Moving This View To Hide
                        .offset(y:menuData.showDrawer ? -8 : 0)
                }
                // nraka7 fel X
                .rotationEffect(.init(degrees: menuData.showDrawer ? 50 : 0))
            }
        })
        // bech ns8er fiha X chwaya
        .scaleEffect(0.8)
        .matchedGeometryEffect(id: "MENU_BUTTON", in: animation)
    }
    
}
