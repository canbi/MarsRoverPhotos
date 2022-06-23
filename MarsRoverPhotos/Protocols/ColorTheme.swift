//
//  ColorTheme.swift
//  MarsRoverPhotos
//
//  Created by Can Bi on 23.06.2022.
//

import SwiftUI

class ColorData {
    private let userDefaults = UserDefaults.standard
    
    func saveColor(color: Color, colorKey: String) {
        // Convert the color into RGB
        let color = UIColor(color).cgColor
        
        // Save the RGB into an array
        if let components = color.components {
            userDefaults.set(components, forKey: colorKey)
        }
    }
    
    func loadColor(for key: String) -> Color? {
        // Get the RGB array
        guard let array = userDefaults.object(forKey: key) as? [CGFloat] else { return nil }
        
        // Create a color from the RGB array
        let color = Color(.sRGB,
                          red: array[0],
                          green: array[1],
                          blue: array[2],
                          opacity: array[3])
        return color
    }
}

protocol CustomColorTheme {
    var tabCuriosity: Color { get }
    var tabOpportunity: Color { get }
    var tabSpirit: Color { get }
}

struct ColorTheme: CustomColorTheme {
    private var colorData = ColorData()
    static private let curiosityKey: String = "curiosityColor"
    static private let opportunityKey: String = "opportunityColor"
    static private let spiritKey: String = "spiritColor"
    
    var tabCuriosity: Color { didSet { colorData.saveColor(color: tabCuriosity, colorKey: ColorTheme.curiosityKey) } }
    var tabOpportunity: Color { didSet { colorData.saveColor(color: tabOpportunity, colorKey: ColorTheme.opportunityKey) } }
    var tabSpirit: Color { didSet { colorData.saveColor(color: tabSpirit, colorKey: ColorTheme.spiritKey) } }
    
    init(){
        self.tabCuriosity = colorData.loadColor(for: ColorTheme.curiosityKey) ?? .red
        self.tabOpportunity = colorData.loadColor(for: ColorTheme.opportunityKey) ?? .blue
        self.tabSpirit = colorData.loadColor(for: ColorTheme.spiritKey) ?? .green
    }
}
