//
//  Home.swift
//  Aqua Guard
//
//  Created by Youssef Farhat on 27/11/2023.
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
                
                My_Calendar()
                    .tag("My Calendar")
                Notification()
                    .tag("Notification")
                My_Posts()
                    .tag("My Events")
                My_Events()
                    .tag("My Posts")
                Command()
                    .tag("My Command")
            }
            .frame(width: UIScreen.main.bounds.width)
        }
        .frame(width: UIScreen.main.bounds.width)
        .offset(x: menuData.showDrawer ?  130 : -130)
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
       
        
    }
}

#Preview {
    Home()
}
