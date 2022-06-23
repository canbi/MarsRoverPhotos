//
//  SettingsViewModel.swift
//  MarsRoverPhotos
//
//  Created by Can Bi on 23.06.2022.
//

import SwiftUI

class SettingsViewModel: ObservableObject {
    @Published var colorCuriosity = Color.theme.tabCuriosity
    @Published var colorOpportunity = Color.theme.tabOpportunity
    @Published var colorSpirit = Color.theme.tabSpirit
    
    var isAnythingChanged: Bool { !isCuriositySame || !isOpportunitySame || !isSpiritSame }
    
    var isCuriositySame: Bool { colorCuriosity == Color.theme.tabCuriosity }
    var isOpportunitySame: Bool { colorOpportunity ==  Color.theme.tabOpportunity }
    var isSpiritSame: Bool { colorSpirit == Color.theme.tabSpirit }
    
    let personalURL = URL(string: "https://canbi.me")!
    let twitterURL = URL(string: "https://twitter.com/Canbiw")!
    let githubURL = URL(string: "https://github.com/canbi")!
    
    init(){}
    
    func applySettings(){
        Color.theme.tabOpportunity = colorOpportunity
        Color.theme.tabSpirit = colorSpirit
        Color.theme.tabCuriosity = colorCuriosity
    }
    
    func resetTheme(){
        colorCuriosity = .red
        colorOpportunity = .blue
        colorSpirit = .green
    }
}
