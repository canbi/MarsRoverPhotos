//
//  SettingsViewModel.swift
//  MarsRoverPhotos
//
//  Created by Can Bi on 23.06.2022.
//

import SwiftUI

class SettingsViewModel: ObservableObject {
    var settingManager: SettingManager?
    
    // Settings
    @Published var selectedTheme: Themes = .olympus
    @Published var saveToPhotoSelection: Bool = false
    
    // Control
    var isAnythingChanged: Bool { !isThemeSame || !isSaveToPhotoSame }
    var isThemeSame: Bool { selectedTheme == settingManager?.theme ?? .olympus }
    var isSaveToPhotoSame: Bool { saveToPhotoSelection == settingManager?.favoritesAlsoSaveToPhotos ?? false }
    
    // Constant
    let personalURL = URL(string: "https://canbi.me")!
    let twitterURL = URL(string: "https://twitter.com/Canbiw")!
    let githubURL = URL(string: "https://github.com/canbi")!
    let apiURL = URL(string: "https://api.nasa.gov/index.html#browseAPI")!
    
    init(){}
    
    func setup(_ settingManager: SettingManager) {
        self.settingManager = settingManager
        self._selectedTheme = Published(initialValue: settingManager.theme)
        self._saveToPhotoSelection = Published(initialValue: settingManager.favoritesAlsoSaveToPhotos)
    }
    
    func applySettings(){
        if let settingManager = settingManager {
            settingManager.theme = selectedTheme
            settingManager.tabCuriosity = selectedTheme.curiosityColor
            settingManager.tabOpportunity = selectedTheme.opportunityColor
            settingManager.tabSpirit = selectedTheme.spiritColor
            settingManager.favoritesAlsoSaveToPhotos = saveToPhotoSelection
        }
    }
}
