//
//  SettingManager.swift
//  MarsRoverPhotos
//
//  Created by Can Bi on 25.06.2022.
//

import SwiftUI

enum GridDesign: String, CaseIterable, Identifiable {
    case oneColumn = "One Column"
    case twoColumn = "Two Column"
    
    var id: Self { self }
}

class SettingManager: ObservableObject {
    static private let themeKey: String = "themeKey"
    
    var theme: Themes {
        didSet {
            UserDefaults.standard.set(theme.rawValue, forKey: SettingManager.themeKey)
        }
    }
    
    @Published var tabCuriosity: Color
    @Published var tabOpportunity: Color
    @Published var tabSpirit: Color
    @Published var gridDesign: GridDesign = .oneColumn
    
    init(){
        self.theme = Themes(rawValue: (UserDefaults.standard.object(forKey: SettingManager.themeKey) ?? "") as! String) ?? .olympus
        
        self._tabCuriosity = Published(initialValue: theme.curiosityColor)
        self._tabOpportunity = Published(initialValue: theme.opportunityColor)
        self._tabSpirit = Published(initialValue: theme.spiritColor)
    }
    
    func getTintColor(roverType: RoverType) -> Color{
        switch roverType {
        case .curiosity: return tabCuriosity
        case .opportunity: return tabOpportunity
        case .spirit: return tabSpirit
        }
    }
    
    func changeGrid(){
        gridDesign = gridDesign == .oneColumn ? .twoColumn : .oneColumn
    }
}
