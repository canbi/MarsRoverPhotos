//
//  SettingsViewModel.swift
//  MarsRoverPhotos
//
//  Created by Can Bi on 23.06.2022.
//

import SwiftUI

class SettingsViewModel: ObservableObject {
    var colorManager: ColorManager?
    @Published var selectedTheme: Themes = .olympus
    
    var isAnythingChanged: Bool { !isThemeSame }
    
    var isThemeSame: Bool { selectedTheme == colorManager?.theme ?? .olympus }
    
    let personalURL = URL(string: "https://canbi.me")!
    let twitterURL = URL(string: "https://twitter.com/Canbiw")!
    let githubURL = URL(string: "https://github.com/canbi")!
    
    init(){
    }
    
    func setup(_ colorManager: ColorManager) {
        self.colorManager = colorManager
        self._selectedTheme = Published(initialValue: colorManager.theme)
      }
    
    func applySettings(){
        if let colorManager = colorManager {
            colorManager.theme = selectedTheme
            colorManager.tabCuriosity = selectedTheme.curiosityColor
            colorManager.tabOpportunity = selectedTheme.opportunityColor
            colorManager.tabSpirit = selectedTheme.spiritColor
        }
    }
}
