//
//  MarsRoverPhotosApp.swift
//  MarsRoverPhotos
//
//  Created by Can Bi on 20.06.2022.
//

import SwiftUI

@main
struct MarsRoverPhotosApp: App {
    @State private var tabSelection: NavBarItem = .curiosity
    var body: some Scene {
        WindowGroup {
            NavigationView {
                CustomTabBarContainerView(selection: $tabSelection) {
                    RoverView(rover: .curiosity)
                        .tabBarItem(tab: .curiosity, selection: $tabSelection)
                    
                    RoverView(rover: .opportunity)
                        .tabBarItem(tab: .opportunity, selection: $tabSelection)
                    
                    RoverView(rover: .spirit)
                        .tabBarItem(tab: .spirit, selection: $tabSelection)
                }
                .navigationBarHidden(true)
            }
        }
    }
}
