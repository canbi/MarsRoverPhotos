//
//  MarsRoverPhotosApp.swift
//  MarsRoverPhotos
//
//  Created by Can Bi on 20.06.2022.
//

import SwiftUI

@main
struct MarsRoverPhotosApp: App {
    @StateObject var colorManager: ColorManager = ColorManager()
    @State private var tabSelection: NavBarItem = .curiosity
    @State var shouldScrollToTop: Bool = false
    var curiosityDataService = JSONDataService()
    var opportunityDataService = JSONDataService()
    var spiritDataService = JSONDataService()

    var body: some Scene {
        WindowGroup {
            NavigationView {
                ScrollView {
                    TabView(selection: $tabSelection) {
                        RoverView(rover: .curiosity, shouldScroolToTop: $shouldScrollToTop, dataService: curiosityDataService)
                            .tag(NavBarItem.curiosity)
                        RoverView(rover: .opportunity, shouldScroolToTop: $shouldScrollToTop, dataService: opportunityDataService)
                            .tag(NavBarItem.opportunity)
                        RoverView(rover: .spirit, shouldScroolToTop: $shouldScrollToTop, dataService: spiritDataService)
                            .tag(NavBarItem.spirit)
                    }
                    .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
                    .indexViewStyle(PageIndexViewStyle(backgroundDisplayMode: .never))
                    .frame(width: UIScreen.main.bounds.width,
                           height: UIScreen.main.bounds.height)
                }
                .ignoresSafeArea()
                .navigationBarHidden(true)
                .overlay(alignment: .bottom) {
                    CustomTabBarView(tabs: [.curiosity, .opportunity, .spirit],
                                     selection: $tabSelection,
                                     localSelection: .curiosity, scrollToTop: $shouldScrollToTop)
                }
            }
            .environmentObject(colorManager)
        }
    }
}
