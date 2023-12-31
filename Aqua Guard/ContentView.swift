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
    @StateObject var actualiteViewModel = ActualiteViewModel()

    @Environment(\.managedObjectContext) private var viewContext
    
    var body: some View {
        NavigationView {
            TabView {
                
               ActualiteListView()
                    .tabItem {
                        Label("Home", systemImage: "house")
                    }.environmentObject(actualiteViewModel)
                EventListView()
                    .tabItem {
                        Label("Events", systemImage: "calendar")
                    }.environmentObject(eventViewModel)
                
                PostListView()
                    .tabItem {
                        Label("Forum", systemImage: "text.bubble.fill")
                    }.environmentObject(postViewModel)
              
                StoreView(viewModel: ProductViewModel())
                
                    .tabItem {
                        Label("Store", systemImage: "bag")
                    }.environmentObject(CartManager())
                Profile()
                    .tabItem {
                        Label("Profile", systemImage: "person.fill")
                    }
                
            }
            .accentColor(.darkBlue)
            
            
            
            // .environmentObject(forumDetailsViewModel)
        }.navigationBarColor(.darkBlue, textColor: UIColor.white)
        
            .background(Image("background_splash_screen")
                .resizable()
                .scaledToFill()
                .edgesIgnoringSafeArea(.all))
            .navigationBarBackButtonHidden(true)
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

