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
    let name, status: String
    let landingDate, launchDate: Date
    let maxSol: Int
    let maxDate: Date
    let totalPhotos: Int
    let photos: [ManifestPhoto]
    let localSaveDate: Date?

    enum CodingKeys: String, CodingKey {
        case name
        case landingDate = "landing_date"
        case launchDate = "launch_date"
        case status
        case maxSol = "max_sol"
        case maxDate = "max_date"
        case totalPhotos = "total_photos"
        case photos
        case localSaveDate
    }
    
    static var previewData: PhotoManifest {
        return .init(name: "Preview",
                     status: "Preview",
                     landingDate: .now,
                     launchDate: .now,
                     maxSol: 12,
                     maxDate: .now,
                     totalPhotos: 12,
                     photos: [],
                     localSaveDate: nil)
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
