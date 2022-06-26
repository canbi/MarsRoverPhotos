//
//  RoverType.swift
//  MarsRoverPhotos
//
//  Created by Can Bi on 26.06.2022.
//

import Foundation


enum RoverType: String, Codable {
    case curiosity = "Curiosity"
    case opportunity = "Opportunity"
    case spirit = "Spirit"
    
    var cameraAvability: [CameraName] {
        switch self {
        case .curiosity: return [.all, .fhaz, .rhaz, .mast, .chemcam, .mahli, .mardi, .navcam]
        case .opportunity: return [.all, .fhaz, .rhaz, .navcam, .pancam, .minites]
        case .spirit: return [.all, .fhaz, .rhaz, .navcam, .pancam, .minites]
        }
    }
}
