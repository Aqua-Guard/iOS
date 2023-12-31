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
    @State private var navigateToLogin = false
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
        .navigationBarBackButtonHidden(true)
        .background(
                  NavigationLink(
                      destination: LoginView(),
                      isActive: $navigateToLogin
                  ) {
                      EmptyView()
                  }
                  .hidden()
              )
    }

    var profileHeader: some View {
        ZStack {
            Image("nav_header")
                .resizable()
                .scaledToFill()
                .frame(height: 200)
                .offset(y: -90)
            VStack {
                AsyncImage(url: URL(string: "https://aquaguard-tux1.onrender.com/images/user/\((LoginViewModell.defaults.string(forKey: "image") ?? ""))")) { phase in
                         switch phase {
                         case .empty:
                             ProgressView()
                         case .success(let image):
                             image
                                 .resizable()
                                 .scaledToFit()
                                 .frame(width: 100, height: 100)
                                 .clipShape(Circle())
                                 .overlay(Circle().stroke(Color.white, lineWidth: 2))
                         case .failure:
                             Image(systemName: "photo") // You can use a placeholder image here
                                 .resizable()
                                 .scaledToFit()
                                 .frame(width: 100, height: 100)
                                 .clipShape(Circle())
                                 .overlay(Circle().stroke(Color.white, lineWidth: 2))
                         @unknown default:
                             EmptyView()
                         }
                     }
                
                
                
                Text((LoginViewModell.defaults.string(forKey: "firstName") ?? "") +  " " + (LoginViewModell.defaults.string(forKey: "lastName") ?? ""))
                    .font(.title)
                    .fontWeight(.heavy)
                    .foregroundColor(.white)
                Text((LoginViewModell.defaults.string(forKey: "email") ?? ""))
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
            case "Settings":
                SettingsView()
            case "Logout":
                LoginView()
                    .onAppear {
                        LoginViewModell.logout()
                        navigateToLogin = true
                        }
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

private var menuItems: [MenuItem] {
      var items: [MenuItem] = [
          MenuItem(name: "My Calendar", icon: "calendar"),
          MenuItem(name: "My Posts", icon: "rectangle.3.group.bubble"),
          MenuItem(name: "My Reclamtion", icon: "exclamationmark.triangle.fill"),
          MenuItem(name: "My Orders", icon: "cart"),
          MenuItem(name: "Settings", icon: "gear"),
          MenuItem(name: "Logout", icon: "rectangle.portrait.and.arrow.right"),
      ]
    print("------ roleee " + (LoginViewModell.defaults.string(forKey: "role") ?? ""))
    print("------ roleee ", LoginViewModell.defaults.string(forKey: "role")?.elementsEqual("partenaire"))

    if ((LoginViewModell.defaults.string(forKey: "role")?.elementsEqual("partenaire")) == true) {
          items.insert(MenuItem(name: "My Events", icon: "calendar.badge.clock"), at: 1) // Insert at the desired position
      }

      return items
  }

#Preview {
    Profile()
}
