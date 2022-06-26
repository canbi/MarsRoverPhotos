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
    
    static var previewData: Camera {
        return .init(id: 1,
                     name: .fhaz,
                     roverID: 1,
                     fullName: .panoramicCamera)
    }
}
