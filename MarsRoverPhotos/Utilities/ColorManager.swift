//
//  ColorManager.swift
//  MarsRoverPhotos
//
//  Created by Can Bi on 25.06.2022.
//

import SwiftUI

class ColorManager: ObservableObject {
    static private let themeKey: String = "themeKey"
    
    var theme: Themes {
        didSet {
            UserDefaults.standard.set(theme.rawValue, forKey: ColorManager.themeKey)
        }
    }
    
    @Published var tabCuriosity: Color
    @Published var tabOpportunity: Color
    @Published var tabSpirit: Color
    
    init(){
        self.theme = Themes(rawValue: (UserDefaults.standard.object(forKey: ColorManager.themeKey) ?? "") as! String) ?? .olympus
        
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
}
