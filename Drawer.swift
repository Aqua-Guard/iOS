//
//  Drawer.swift
//  Aqua Guard
//
//  Created by Youssef Farhat on 27/11/2023.
//

import SwiftUI

struct Drawer: View {
    @EnvironmentObject var menuData:DrawerMenuViewModel
    var animation : Namespace.ID
    var body: some View {
        VStack{
            HStack{
                
                Image("youssef")
                    .resizable()
                    .aspectRatio(contentMode: /*@START_MENU_TOKEN@*/.fill/*@END_MENU_TOKEN@*/)
                    .frame(width: 65,height: 65)
                    .clipShape(/*@START_MENU_TOKEN@*/Circle()/*@END_MENU_TOKEN@*/)
                Spacer()
                // Close Button
                
                if menuData.showDrawer {
                    DrawerCloseButton(animation: animation)
                }
            }
            .padding()
            VStack(alignment: .leading, spacing: 10,content: {
            Text("Home")
                    .font(.title2)
            Text("Youssef Farhat")
                    .font(.title)
                    .fontWeight(.heavy)
            })
            .foregroundColor(.white)
            .frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/,alignment: .leading)
            .padding(.horizontal)
            .padding(.top,5)
            // menue button
            VStack(spacing: 10){
                DrawerMenuButton(name:"My Calendar",image: "calendar",selectedMenu: $menuData.selectedMenu,animation: animation)
                    
                DrawerMenuButton(name:"Notification",image: "bell.fill",selectedMenu: $menuData.selectedMenu,animation: animation)
                DrawerMenuButton(name:"My Event",image: "calendar.badge.clock",selectedMenu: $menuData.selectedMenu,animation: animation)
                DrawerMenuButton(name:"My Post",image: "rectangle.3.group.bubble",selectedMenu: $menuData.selectedMenu,animation: animation)
                DrawerMenuButton(name:"Command",image: "bag.circle",selectedMenu: $menuData.selectedMenu,animation: animation)


            }
            .padding(.leading)
            .frame(width: 260,alignment: .leading)
            .padding(.top,30)
            
            Divider()
                .frame(height: 2)
                .background(Color.white)
                .padding(.top,30)
                .padding(.horizontal,25)
            Spacer()
            DrawerMenuButton(name:"Logout",image: "rectangle.portrait.and.arrow.forward",selectedMenu: .constant(""),animation: animation)
                .padding(.bottom)
        }
        .frame(width: 260)
        .background(
        Color("babyBlue")
            .ignoresSafeArea(.all,edges: .vertical))
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
                    .fill(menuData.showDrawer ? Color.white : Color.primary)
                    .frame(width: 35,height: 3)
                    .rotationEffect(.init(degrees: menuData.showDrawer ? -50 : 0))
                // nraka7 fel X
                // ntala fiha bethabet 9Adech lezem bech terka7
                    .offset(x:menuData.showDrawer ? 2 : 0 , y: menuData.showDrawer ? 9 : 0)
                VStack(spacing: 5){
                    Capsule()
                        .fill(menuData.showDrawer ? Color.white : Color.primary)
                        .frame(width: 35,height: 3)
                    Capsule()
                        .fill(menuData.showDrawer ? Color.white : Color.primary)
                        .frame(width: 35,height: 3)
                    // Moving This View To Hide
                        .offset(y:menuData.showDrawer ? -8 : 0)
                }
                // nraka7 fel X
                .rotationEffect(.init(degrees: menuData.showDrawer ? 50 : 0))
            }
        })
        // bech ns8er fiha chwaya
        .scaleEffect(0.8)
        .matchedGeometryEffect(id: "MENU_BUTTON", in: animation)
    }
}
