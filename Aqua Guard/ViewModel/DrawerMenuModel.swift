//
//  DrawerMenuModel.swift
//  Aqua Guard
//
//  Created by Youssef Farhat on 27/11/2023.
//

import SwiftUI

// Menu Data...
class DrawerMenuViewModel: ObservableObject{
    @Published
    var selectedMenu = "Notification"
    
    //Show ..
    @Published var showDrawer = false
}
