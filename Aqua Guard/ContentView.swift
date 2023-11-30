//
//  ContentView.swift
//  Aqua Guard
//
//  Created by Malek Labidi on 27/11/2023.
//

import SwiftUI
import CoreData

struct ContentView: View {
    @StateObject var postViewModel = PostViewModel()
    @StateObject var eventViewModel = EventViewModel()
    @Environment(\.managedObjectContext) private var viewContext
    
    var body: some View {
        NavigationView {
            TabView {
                
                Text("Home")
                    .tabItem {
                        Label("Home", systemImage: "house")
                    }
                EventListView()
                    .tabItem {
                        Label("Events", systemImage: "calendar")
                    }.environmentObject(eventViewModel)
                
                PostListView()
                    .tabItem {
                        Label("Forum", systemImage: "text.bubble.fill")
                    }.environmentObject(postViewModel)
                
                
                Text("Store")
                    .tabItem {
                        Label("Store", systemImage: "bag")
                    }
                
                
            }
            .accentColor(.darkBlue)
            
            
            
            // .environmentObject(forumDetailsViewModel)
        }.navigationBarColor(.darkBlue, textColor: UIColor.white)
        
            .background(Image("background_splash_screen")
                .resizable()
                .scaledToFill()
                .edgesIgnoringSafeArea(.all))
    }
    
}

extension View {
    func navigationBarColor(_ backgroundColor: UIColor, textColor: UIColor) -> some View {
        modifier(NavigationBarModifier(backgroundColor: backgroundColor, textColor: textColor))
    }
}


struct NavigationBarModifier: ViewModifier {
    var backgroundColor: UIColor
    var textColor: UIColor
    
    init(backgroundColor: UIColor, textColor: UIColor) {
        self.backgroundColor = backgroundColor
        self.textColor = textColor
    }
    
    func body(content: Content) -> some View {
        content
            .onAppear {
                let coloredAppearance = UINavigationBarAppearance()
                coloredAppearance.configureWithOpaqueBackground()
                coloredAppearance.backgroundColor = backgroundColor
                coloredAppearance.titleTextAttributes = [.foregroundColor: textColor]
                coloredAppearance.largeTitleTextAttributes = [.foregroundColor: textColor]
                
                UINavigationBar.appearance().standardAppearance = coloredAppearance
                UINavigationBar.appearance().scrollEdgeAppearance = coloredAppearance
            }
    }
}


// Preview code
#if DEBUG
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
#endif

