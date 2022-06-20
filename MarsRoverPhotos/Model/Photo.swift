//
//  Api.swift
//  MarsRoverPhotos
//
//  Created by Can Bi on 20.06.2022.
//

import Foundation

struct MarsPhotos: Codable {
    let photos: [Photo]
}

struct Photo: Codable {
    let id: Int
    let sol: Int
    let camera: Camera
    let imgSrc: String
    let earthDate: String
    let rover: Rover

    enum CodingKeys: String, CodingKey {
        case id, sol, camera
        case imgSrc = "img_src"
        case earthDate = "earth_date"
        case rover
    }
}
