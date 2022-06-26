//
//  PhotoDataService.swift
//  MarsRoverPhotos
//
//  Created by Can Bi on 20.06.2022.
//

import Foundation
import Combine

class JSONDataService: ObservableObject {
    static var previewInstance = JSONDataService(.curiosity)
    
    var roverType: RoverType
    @Published var allPhotos: [Photo] = []
    @Published var manifest: PhotoManifest! { didSet { checkManifestInUserDefaults() }}
    
    init(_ roverType: RoverType){
        self.roverType = roverType
    }
    
    var photoSubscription: AnyCancellable?
    var manifestSubscription: AnyCancellable?
    
    var isManifestSavedKey: String { "isManifestSavedFor\(roverType.rawValue)" }
}

// MARK: - Manifest Functions
extension JSONDataService {
    func saveManifestToUserDefaults(){
        let localManifest = PhotoManifest(name: manifest.name,
                                          status: manifest.status,
                                          landingDate: manifest.landingDate,
                                          launchDate: manifest.launchDate,
                                          maxSol: manifest.maxSol,
                                          maxDate: manifest.maxDate,
                                          totalPhotos: manifest.totalPhotos,
                                          photos: [],
                                          localSaveDate: .now)
        let defaults = UserDefaults.standard
        
        defaults.set(true, forKey: isManifestSavedKey)
        
        if let encoded = try? JSONEncoder().encode(localManifest) {
            defaults.set(encoded, forKey: roverType.rawValue)
        }
    }
    
    func loadManifestFromUserDefaults() -> PhotoManifest? {
        var returnedManifest: PhotoManifest? = nil
        
        if let savedManifest = UserDefaults.standard.object(forKey: roverType.rawValue) as? Data {
            let decoder = JSONDecoder()
            if let loadedManifest = try? decoder.decode(PhotoManifest.self, from: savedManifest) {
                returnedManifest = loadedManifest
            }
        }
        return returnedManifest
    }
    
    func getInformation(of rover: RoverType){
        let endpoint = Endpoint.getInformation(rover: rover)
        
        guard let url = endpoint.url else { return }
        
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .formatted(DateFormatter.yyyyMMdd)
        
        manifestSubscription = NetworkingManager.download(url: url)
            .decode(type: Manifest.self, decoder: decoder)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: NetworkingManager.handleCompletion, receiveValue: { [weak self] (returnedManifest) in
                self?.manifest = returnedManifest.photoManifest
                self?.manifestSubscription?.cancel()
            })
    }
    
    func checkManifestInUserDefaults() {
        let isManifestSaved = UserDefaults.standard.bool(forKey: isManifestSavedKey)
        let lastSaveDate = loadManifestFromUserDefaults()?.localSaveDate ?? .distantPast
        if !isManifestSaved || Calendar(identifier: .gregorian).numberOfDaysBetween(lastSaveDate, and: .now) > 1 {
            saveManifestToUserDefaults()
        }
    }
}

// MARK: - Photo Functions
extension JSONDataService {
    func getPhotosBySol(rover: RoverType, sol: Int, cameraType: CameraName, sortingType: SortingType) {
        let endpoint = Endpoint.getPhotos(rover: rover, sol: sol, cameraType: cameraType)
        
        guard let url = endpoint.url else { return }
        
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .formatted(DateFormatter.yyyyMMdd)
        
        photoSubscription = NetworkingManager.download(url: url)
            .decode(type: MarsPhotos.self, decoder: decoder)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: NetworkingManager.handleCompletion, receiveValue: { [weak self] (returnedPhotos) in
                guard let self = self else { return }
                self.allPhotos = self.sortAccordingToType(returnedPhotos.photos, sortType: sortingType)
                self.photoSubscription?.cancel()
            })
    }
    
    func getPhotosByEarthDate(rover: RoverType, earthDate: Date, cameraType: CameraName, sortingType: SortingType) {
        let endpoint = Endpoint.getPhotos(rover: rover, earthDate: earthDate, cameraType: cameraType)
        
        guard let url = endpoint.url else { return }
        
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .formatted(DateFormatter.yyyyMMdd)
        
        photoSubscription = NetworkingManager.download(url: url)
            .decode(type: MarsPhotos.self, decoder: decoder)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: NetworkingManager.handleCompletion, receiveValue: { [weak self] (returnedPhotos) in
                guard let self = self else { return }
                self.allPhotos = self.sortAccordingToType(returnedPhotos.photos, sortType: sortingType)
                self.photoSubscription?.cancel()
            })
    }
    
    func sortAccordingToType(_ willSort: [Photo], sortType: SortingType) -> [Photo] {
        switch sortType {
        case .ascending:
            return willSort
        case .descending:
            return willSort.sorted{ $0 > $1}
        case .random:
            return willSort.shuffled()
        }
    }
}
