//
//  CameraFullName.swift
//  MarsRoverPhotos
//
//  Created by Can Bi on 26.06.2022.
//

import Foundation

enum CameraFullName: String, Codable {
    case noInfo = "No Information"
    case allCameras = "All Cameras"
    case entryCamera = "Entry Camera"
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
