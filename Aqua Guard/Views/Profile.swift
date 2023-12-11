//
//  Profile.swift
//  Aqua Guard
//
//  Created by Youssef Farhat on 4/12/2023.
//

import SwiftUI
struct Profile: View {
    @StateObject var eventViewModel = MyEventViewModel()
    @StateObject var postViewModel = PostViewModel()
    var body: some View {
        NavigationView {
            List {
                // The profile header
                Section(header: profileHeader) {
                    EmptyView()
                }
                
                // Menu items
                ForEach(menuItems, id: \.self) { item in
                    NavigationLink(destination: destinationView(for: item)) {
                        HStack {
                            Image(systemName: item.icon)
                                .foregroundColor(.darkBlue)
                                .frame(width: 30, alignment: .center)
                            Text(item.name)
                                .foregroundColor(.darkBlue)
                        }
                        .padding(.vertical, 8) // Add padding to each menu item for better spacing
                    }
                    .listRowBackground(Color.white.opacity(0)) // Set each row's background to white
                    .padding(.horizontal) // Add padding on the sides
                }
                
                
            }
            .listStyle(PlainListStyle())
           // .navigationBarHidden(true)
            .background(
                Image("background_splash_screen")
                    .resizable()
                    .scaledToFill()
                    .edgesIgnoringSafeArea(.all)
            )
        }.accentColor(.white)
        .navigationBarColor(.darkBlue, textColor: UIColor.white)
        
    }

    var profileHeader: some View {
        ZStack {
            Image("nav_header")
                .resizable()
                .scaledToFill()
                .frame(height: 200)
                .offset(y: -90)
            VStack {
                Image("youssef")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 100, height: 100)
                    .clipShape(Circle())
                    .overlay(Circle().stroke(Color.white, lineWidth: 2))
                Text("Youssef Farhat")
                    .font(.title)
                    .fontWeight(.heavy)
                    .foregroundColor(.white)
                Text("Youssef.farhat@esprit. tn")
                    .font(.title3)
                    .fontWeight(.light)
                    .foregroundColor(.white)
            }
            .offset(y: -40)
        }
        .frame(height: 200)
        .listRowInsets(EdgeInsets())
    }

    private func destinationView(for menuItem: MenuItem) -> some View {
        Group {
            switch menuItem.name {
            case "My Calendar":
                MyCalendar()
            case "My Events":
                MyEvents()
                    .environmentObject(eventViewModel)
            case "My Posts":
                MyPosts()
                    .environmentObject(postViewModel)
            case "My Reclamtion":
                ReclamationListView()
            default:
                Text("Placeholder")
            }
        }
    }

}

struct MenuItem: Hashable {
    let name: String
    let icon: String
}

let menuItems: [MenuItem] = [
    MenuItem(name: "My Calendar", icon: "calendar"),
    //MenuItem(name: "Notification", icon: "bell.fill"),
    MenuItem(name: "My Events", icon: "calendar.badge.clock"),
    MenuItem(name: "My Posts", icon: "rectangle.3.group.bubble"),
    MenuItem(name: "My Reclamtion", icon: "exclamationmark.triangle.fill"),
]

#Preview {
    Profile()
}
