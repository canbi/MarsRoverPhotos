//
//  SettingsViewModel.swift
//  MarsRoverPhotos
//
//  Created by Can Bi on 23.06.2022.
//

import SwiftUI

class SettingsViewModel: ObservableObject {
    @Published var colorCuriosity = Color.theme.tabCuriosity{
        didSet {
            Color.theme.tabCuriosity = colorCuriosity
        }
    }
    @Published var colorOpportunity = Color.theme.tabOpportunity {
        didSet {
            Color.theme.tabOpportunity = colorOpportunity
        }
    }
    @Published var colorSpirit = Color.theme.tabSpirit {
        didSet {
            Color.theme.tabSpirit = colorSpirit
        }
    }
    
    let personalURL = URL(string: "https://canbi.me")!
    let twitterURL = URL(string: "https://twitter.com/Canbiw")!
    let githubURL = URL(string: "https://github.com/canbi")!
    
    init(){
        
    }
    
    func resetTheme(){
        colorCuriosity = .red
        colorOpportunity = .blue
        colorSpirit = .green
    }
}
