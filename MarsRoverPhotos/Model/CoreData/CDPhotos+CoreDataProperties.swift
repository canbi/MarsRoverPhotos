//
//  CDPhotos+CoreDataProperties.swift
//  MarsRoverPhotos
//
//  Created by Can Bi on 25.06.2022.
//
//

import Foundation
import CoreData


extension CDPhotos {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CDPhotos> {
        return NSFetchRequest<CDPhotos>(entityName: "CDPhotos")
    }

    @NSManaged public var id: Int16
    @NSManaged public var roverName: String?
    @NSManaged public var addFavoritesDate: Date?
    @NSManaged public var sol: Int16
    @NSManaged public var earthDate: Date?
    @NSManaged public var cameraName: String?
    
    var wrappedRoverType: RoverType { RoverType(rawValue: roverName ?? "") ?? .curiosity }
    var wrappedCameraType: CameraName { CameraName(rawValue: cameraName ?? "") ?? .entry }

}

extension CDPhotos : Identifiable {

}
