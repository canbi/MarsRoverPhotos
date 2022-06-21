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
    var dataService1 = JSONDataService()
    var dataService2 = JSONDataService()
    var dataService3 = JSONDataService()
    
    init(){
    }
    
    var body: some Scene {
        WindowGroup {
            NavigationView {
                TabView(selection: $tabSelection) {
                    RoverView(rover: .curiosity, dataService: dataService1)
                        .tag(NavBarItem.curiosity)
                    RoverView(rover: .opportunity, dataService: dataService2)
                        .tag(NavBarItem.opportunity)
                    RoverView(rover: .spirit, dataService: dataService3)
                        .tag(NavBarItem.spirit)
                }
                .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
                .indexViewStyle(PageIndexViewStyle(backgroundDisplayMode: .never))
                .navigationBarHidden(true)
                .overlay(alignment: .bottom) {
                    CustomTabBarView(tabs: [.curiosity,.opportunity,.spirit], selection: $tabSelection, localSelection: .curiosity)
                }
            }
        }
    }
}
