//
//  MarsRoverPhotosApp.swift
//  MarsRoverPhotos
//
//  Created by Can Bi on 20.06.2022.
//

import SwiftUI

@main
struct MarsRoverPhotosApp: App {
    // Environment
    @StateObject private var cdDataService = CoreDataDataService(moc: CoreDataController().container.viewContext)
    @StateObject var settingManager: SettingManager = SettingManager()
    
    // Control
    @State private var tabSelection: NavBarItem = .curiosity
    @State var shouldScrollToTop: Bool = false
    
    // Service
    var curiosityDataService = JSONDataService(.curiosity)
    var opportunityDataService = JSONDataService(.opportunity)
    var spiritDataService = JSONDataService(.spirit)
    
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
            .environmentObject(cdDataService)
            .environmentObject(settingManager)
        }
    }
}
