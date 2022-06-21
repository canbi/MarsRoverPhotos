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
    var curiosityDataService = JSONDataService()
    var opportunityDataService = JSONDataService()
    var spiritDataService = JSONDataService()

    var body: some Scene {
        WindowGroup {
            NavigationView {
                TabView(selection: $tabSelection) {
                    RoverView(rover: .curiosity, dataService: curiosityDataService)
                        .tag(NavBarItem.curiosity)
                    RoverView(rover: .opportunity, dataService: opportunityDataService)
                        .tag(NavBarItem.opportunity)
                    RoverView(rover: .spirit, dataService: spiritDataService)
                        .tag(NavBarItem.spirit)
                }
                .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
                .indexViewStyle(PageIndexViewStyle(backgroundDisplayMode: .never))
                .navigationBarHidden(true)
                .overlay(alignment: .bottom) {
                    CustomTabBarView(tabs: [.curiosity, .opportunity, .spirit],
                                     selection: $tabSelection,
                                     localSelection: .curiosity)
                }
            }
        }
    }
}
