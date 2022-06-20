//
//  Rover.swift
//  MarsRoverPhotos
//
//  Created by Can Bi on 20.06.2022.
//

import Foundation

struct Rover: Codable {
    let id: Int
    let name: RoverType
    let landingDate: String
    let launchDate: String
    let status: String

    enum CodingKeys: String, CodingKey {
        case id, name
        case landingDate = "landing_date"
        case launchDate = "launch_date"
        case status
    }
}

enum RoverType: String, Codable {
    case curiosity = "Curiosity"
    case opportunity = "Opportunity"
    case spirit = "Spirit"
    
    var cameraAvability: [CameraName] {
        switch self {
        case .curiosity: return [.fhaz, .rhaz, .mast, .chemcam, .mahli, .mardi, .navcam]
        case .opportunity: return [.fhaz, .rhaz, .navcam, .pancam, .minites]
        case .spirit: return [.fhaz, .rhaz, .navcam, .pancam, .minites]
        }
    }
}
