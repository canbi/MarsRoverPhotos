//
//  SettingManager.swift
//  MarsRoverPhotos
//
//  Created by Can Bi on 25.06.2022.
//

import SwiftUI

class SettingManager: ObservableObject {
    private let defaults = UserDefaults.standard
    
    var theme: Themes {
        didSet {
            defaults.set(theme.rawValue, forKey: SettingManager.themeKey)
        }
    }
    
    @Published var tabCuriosity: Color
    @Published var tabOpportunity: Color
    @Published var tabSpirit: Color
    @Published var gridDesign: GridDesign = .oneColumn {
        didSet {
            defaults.set(gridDesign.rawValue, forKey: SettingManager.gridDesignKey)
        }
    }
    @Published var favoritesAlsoSaveToPhotos: Bool = false {
        didSet {
            defaults.set(favoritesAlsoSaveToPhotos, forKey: SettingManager.saveToPhotosKey)
        }
    }
    @Published var favoritesAlsoSaveForOffline: Bool = false{
        didSet {
            defaults.set(favoritesAlsoSaveForOffline, forKey: SettingManager.saveForOfflineKey)
        }
    }
    
    init(){
        self.theme = Themes(rawValue: (defaults.string(forKey: SettingManager.themeKey) ?? "")) ?? .olympus
        
        self._gridDesign = Published(initialValue: GridDesign(rawValue: (defaults.string(forKey: SettingManager.gridDesignKey) ?? "")) ?? .oneColumn)
        self._favoritesAlsoSaveToPhotos = Published(initialValue: defaults.bool(forKey: SettingManager.saveToPhotosKey))
        self._favoritesAlsoSaveForOffline = Published(initialValue: defaults.bool(forKey: SettingManager.saveForOfflineKey))
        
        self._tabCuriosity = Published(initialValue: theme.curiosityColor)
        self._tabOpportunity = Published(initialValue: theme.opportunityColor)
        self._tabSpirit = Published(initialValue: theme.spiritColor)
    }
}

// MARK: Functions
extension SettingManager {
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

// MARK: Keys
extension SettingManager {
    static private let themeKey: String = "themeKey"
    static private let saveToPhotosKey: String = "saveToPhotosKey"
    static private let saveForOfflineKey: String = "saveForOfflineKey"
    static private let gridDesignKey: String = "gridDesignKey"
}
