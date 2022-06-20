//
//  Camera.swift
//  MarsRoverPhotos
//
//  Created by Can Bi on 20.06.2022.
//

import Foundation

struct Camera: Codable {
    let id: Int
    let name: CameraName
    let roverID: Int
    let fullName: CameraFullName

    enum CodingKeys: String, CodingKey {
        case id, name
        case roverID = "rover_id"
        case fullName = "full_name"
    }
}

enum CameraFullName: String, Codable {
    case frontHazardAvoidanceCamera = "Front Hazard Avoidance Camera"
    case rearHazardAvoidanceCamera = "Rear Hazard Avoidance Camera"
    case mastCamera = "Mast Camera"
    case chemistryAndCameraComplex = "Chemistry and Camera Complex"
    case marsHandLensImager = "Mars Hand Lens Imager"
    case marsDescentImager = "Mars Descent Imager"
    case navigationCamera = "Navigation Camera"
    case panoramicCamera = "Panoramic Camera"
    case miniatureThermalEmissionSpectrometerMiniTES = "Miniature Thermal Emission Spectrometer (Mini-TES)"
}

enum CameraName: String, Codable {
    case fhaz = "FHAZ"
    case rhaz = "RHAZ"
    case mast = "MAST"
    case chemcam = "CHEMCAM"
    case mahli = "MAHLI"
    case mardi = "MARDI"
    case navcam = "NAVCAM"
    case pancam = "PANCAM"
    case minites = "MINITES"
    
    var fullName: CameraFullName {
        switch self {
        case .fhaz: return .frontHazardAvoidanceCamera
        case .rhaz: return .rearHazardAvoidanceCamera
        case .mast: return .mastCamera
        case .chemcam: return .chemistryAndCameraComplex
        case .mahli: return .marsHandLensImager
        case .mardi: return .marsDescentImager
        case .navcam: return .navigationCamera
        case .pancam: return .panoramicCamera
        case .minites: return .miniatureThermalEmissionSpectrometerMiniTES
        }
    }
}
