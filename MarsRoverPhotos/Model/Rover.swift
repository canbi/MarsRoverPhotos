//
//  Rover.swift
//  MarsRoverPhotos
//
//  Created by Can Bi on 20.06.2022.
//

import SwiftUI

struct Rover: Codable {
    let id: Int
    let name: RoverType
    let landingDate: Date
    let launchDate: Date
    let status: String

    enum CodingKeys: String, CodingKey {
        case id, name
        case landingDate = "landing_date"
        case launchDate = "launch_date"
        case status
    }
    
    static var previewData: Rover {
        return .init(id: 1,
                     name: .curiosity,
                     landingDate: Date.now,
                     launchDate: Date.now,
                     status: "dummy")
    }
}

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
