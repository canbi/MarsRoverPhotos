//
//  ColorTheme.swift
//  MarsRoverPhotos
//
//  Created by Can Bi on 23.06.2022.
//

import SwiftUI

enum Themes: String, CaseIterable, Identifiable  {
    case olympus = "Olympus Mons"
    case ascraeus = "Ascraeus Mons"
    case arsia = "Arsia Mons"
    
    var curiosityColor: Color {
        switch self {
        case .olympus: return .red
        case .ascraeus: return .red
        case .arsia: return .primary
        }
    }
    
    var opportunityColor: Color {
        switch self {
        case .olympus: return .blue
        case .ascraeus: return .orange
        case .arsia: return .secondary
        }
    }
    
    var spiritColor: Color {
        switch self {
        case .olympus: return .green
        case .ascraeus: return .brown
        case .arsia: return .brown
        }
    }
    
    var id: Self { self }
}
