//
//  CoreDataService.swift
//  MarsRoverPhotos
//
//  Created by Can Bi on 25.06.2022.
//


import SwiftUI
import CoreData

class CoreDataDataService: ObservableObject {
    var moc: NSManagedObjectContext
    @Published var favoritesCuriosity: [CDPhotos]
    @Published var favoritesOpportunity: [CDPhotos]
    @Published var favoritesSpirit: [CDPhotos]
    
    init(moc: NSManagedObjectContext) {
        self.moc = moc
        
        let fetchRequestCuriosity: NSFetchRequest<CDPhotos> = CDPhotos.fetchRequest()
        fetchRequestCuriosity.predicate = NSPredicate(format: "roverName = %@", "Curiosity")
        let fetchRequestOpportunity: NSFetchRequest<CDPhotos> = CDPhotos.fetchRequest()
        fetchRequestOpportunity.predicate = NSPredicate(format: "roverName = %@", "Opportunity")
        let fetchRequestSpirit: NSFetchRequest<CDPhotos> = CDPhotos.fetchRequest()
        fetchRequestSpirit.predicate = NSPredicate(format: "roverName = %@", "Spirit")
        
        do {
            self.favoritesCuriosity = try self.moc.fetch(fetchRequestCuriosity) as [CDPhotos]
        } catch let error {
            print("error FetchRequest curiosity \(error)")
            self.favoritesCuriosity = []
        }
        
        do {
            self.favoritesOpportunity = try self.moc.fetch(fetchRequestOpportunity) as [CDPhotos]
        } catch let error {
            print("error FetchRequest opportunity \(error)")
            self.favoritesOpportunity = []
        }
        
        do {
            self.favoritesSpirit = try self.moc.fetch(fetchRequestSpirit) as [CDPhotos]
        } catch let error {
            print("error FetchRequest spirit \(error)")
            self.favoritesSpirit = []
        }
    }
    
    func saveMOC() {
        if self.moc.hasChanges {
            try? self.moc.save()
            
            favoritesCuriosity = getPhotos(for: .curiosity)
            favoritesOpportunity = getPhotos(for: .opportunity)
            favoritesSpirit = getPhotos(for: .spirit)
        }
    }
    
    func getPhotos(for roverType: RoverType) -> [CDPhotos] {
        let fetchRequest: NSFetchRequest<CDPhotos> = CDPhotos.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "roverName = %@", "\(roverType.rawValue)")
        
        var returnedPhotos: [CDPhotos] = []
        
        do {
            returnedPhotos = try self.moc.fetch(fetchRequest) as [CDPhotos]
        } catch let error {
            print("error FetchRequest spirit \(error)")
            returnedPhotos = []
        }
        
        return returnedPhotos
    }
    
    func savePhoto(for roverType: RoverType, photo: Photo) {
        let newPhoto = CDPhotos(context: self.moc)
        newPhoto.id = Int16(photo.id)
        newPhoto.addFavoritesDate = .now
        newPhoto.roverName = photo.rover.name.rawValue
        newPhoto.earthDate = photo.earthDate
        newPhoto.sol = Int16(photo.sol)
        newPhoto.cameraName = photo.camera.name.rawValue
        
        saveMOC()
    }
}
