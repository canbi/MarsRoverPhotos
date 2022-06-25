//
//  SettingsViewModel.swift
//  MarsRoverPhotos
//
//  Created by Can Bi on 23.06.2022.
//

import SwiftUI

class SettingsViewModel: ObservableObject {
    var settingManager: SettingManager?
    @Published var selectedTheme: Themes = .olympus
    
    var isAnythingChanged: Bool { !isThemeSame }
    
    var isThemeSame: Bool { selectedTheme == settingManager?.theme ?? .olympus }
    
    let personalURL = URL(string: "https://canbi.me")!
    let twitterURL = URL(string: "https://twitter.com/Canbiw")!
    let githubURL = URL(string: "https://github.com/canbi")!
    
    init(){
    }
    
    func setup(_ settingManager: SettingManager) {
        self.settingManager = settingManager
        self._selectedTheme = Published(initialValue: settingManager.theme)
      }
    
    func applySettings(){
        if let settingManager = settingManager {
            settingManager.theme = selectedTheme
            settingManager.tabCuriosity = selectedTheme.curiosityColor
            settingManager.tabOpportunity = selectedTheme.opportunityColor
            settingManager.tabSpirit = selectedTheme.spiritColor
        }
    }
}
