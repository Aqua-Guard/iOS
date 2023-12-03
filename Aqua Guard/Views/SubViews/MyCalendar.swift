//
//  MyCalendar.swift
//  Aqua Guard
//
//  Created by Malek Labidi on 28/11/2023.
//

import SwiftUI

struct MyCalendar: View {
    var body: some View {
        NavigationView{
            ZStack {
                           // Background image
                           Image("background_splash_screen")
                               .resizable()
                               .aspectRatio(contentMode: .fill)
                               .edgesIgnoringSafeArea(.all)
                           
                           // Your content here
                           Text("MY calendar")
                .navigationTitle("My Calendar")                       }
        }
       
    }
}

#Preview {
    MyCalendar()
}
