//
//  Home.swift
//  Aqua Guard
//
//  Created by Youssef Farhat on 28/11/2023.
//

import SwiftUI

struct Home: View {
    init() {
        UITabBar.appearance().isHidden = true
    }
    @StateObject var menuData = DrawerMenuViewModel()
    @Namespace var animation
    var body: some View {
        HStack(spacing: 0){
        
            Drawer(animation: animation)
            // Main View
            
            TabView(selection: $menuData.selectedMenu){
                MyEvents()
                    .tag("My Events")
                Command()
                    .tag("Command")
                MyCalendar()
                    .tag("My Calendar")
                Notification()
                    .tag("Notification")
                MyPosts()
                    .tag("MyPosts")
            
            }
            .frame(width: UIScreen.main.bounds.width)
        
        }
        .frame(width: UIScreen.main.bounds.width)
        .offset(x: menuData.showDrawer ?  130 : -130)
        //.offset(x:130)
        .overlay(
        
            ZStack{
                if !menuData.showDrawer{
                    DrawerCloseButton(animation: animation).padding()
                    
                }
            },
            alignment: .topLeading
        )
        // Setting
        .environmentObject(menuData)
        // this is for my bottom navigation bar help me bind between my drawer and this navigation bottom
        HStack {
            Text("Home")
                .tabItem {
                    Label("Home", systemImage: "house")
                }
            Text("event")
                .tabItem {
                    Label("Events", systemImage: "calendar")
                }
            Text("Forum")
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
    


#Preview {
    Home()
}

