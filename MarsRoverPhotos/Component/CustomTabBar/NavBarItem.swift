//
//  NavBarItem.swift
//  FlavorDiary
//
//  Created by Can Bi on 20.03.2022.
//

import Foundation
import SwiftUI

enum NavBarItem: Hashable {
    case curiosity, opportunity, spirit
    
    var color: Color {
        switch self {
        case .curiosity: return .red//Color.theme.tabFirst
        case .opportunity: return .blue//Color.theme.tabSecond
        case .spirit: return .green//Color.theme.tabThird
        }
    }
    
    var iconName: String {
        switch self {
        case .curiosity: return "c.circle.fill"
        case .opportunity: return "o.circle.fill"
        case .spirit: return "s.circle.fill"
        }
    }
    
    var tabTitle: String {
        switch self {
        case .curiosity: return "uriosity"
        case .opportunity: return "pportunity"
        case .spirit: return "pirit"
        }
    }
}
