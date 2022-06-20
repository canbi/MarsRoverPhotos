//
//  Manifest.swift
//  MarsRoverPhotos
//
//  Created by Can Bi on 20.06.2022.
//

import Foundation

// MARK: - Welcome
struct Manifest: Codable {
    let photoManifest: PhotoManifest

    enum CodingKeys: String, CodingKey {
        case photoManifest = "photo_manifest"
    }
}

// MARK: - PhotoManifest
struct PhotoManifest: Codable {
    let name, landingDate, launchDate, status: String
    let maxSol: Int
    let maxDate: String
    let totalPhotos: Int
    let photos: [ManifestPhoto]

    enum CodingKeys: String, CodingKey {
        case name
        case landingDate = "landing_date"
        case launchDate = "launch_date"
        case status
        case maxSol = "max_sol"
        case maxDate = "max_date"
        case totalPhotos = "total_photos"
        case photos
    }
}

// MARK: - Manifest Photo
struct ManifestPhoto: Codable {
    let sol: Int
    let earthDate: String
    let totalPhotos: Int
    let cameras: [CameraName]

    enum CodingKeys: String, CodingKey {
        case sol
        case earthDate = "earth_date"
        case totalPhotos = "total_photos"
        case cameras
    }
}
