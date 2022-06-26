//
//  CameraName.swift
//  MarsRoverPhotos
//
//  Created by Can Bi on 26.06.2022.
//

import Foundation

enum CameraName: String, Codable, CaseIterable, Identifiable {
    case noInfo = "No Info"
    case all = "All Cameras"
    case entry = "ENTRY"
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
        case .noInfo: return .noInfo
        case .all: return .allCameras
        case .entry: return .entryCamera
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
    
    var id: Self { self }
}
