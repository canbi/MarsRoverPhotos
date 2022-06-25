//
//  RoverViewModel.swift
//  MarsRoverPhotos
//
//  Created by Can Bi on 20.06.2022.
//

import Combine
import SwiftUI

enum SortingTypes: String,CaseIterable, Identifiable {
    case ascending = "Ascending"
    case descending = "Descending"
    case random = "Random"
    
    var id: Self { self }
}

enum DateTypes: String, CaseIterable, Identifiable {
    case sol = "Martian Sol"
    case earthDate = "Earth Date"
    
    var id: Self { self }
}

class RoverViewModel: ObservableObject {
    let rover: RoverType
    var networkMonitor: NetworkMonitor? = nil
    
    // Data
    private var dataService: JSONDataService
    @Published var roverImages: [Photo] = [] {
        didSet {
            showingOnlyFavorites = false
            earthDate = roverImages.first?.earthDate ?? earthDate
            sol = roverImages.first?.sol ?? sol
        }
    }
    @Published var roverManifest: PhotoManifest?
    private var cancellables = Set<AnyCancellable>()
    
    // Core Data
    var coreDataService: CoreDataDataService!
    var favoritePhotos: [CDPhotos] = []
    @Published var favoritePhotosAsPhoto: [Photo] = []
    
    // Controls
    @Published var selectedImage: Photo? = nil
    @Published var selectedOfflineImage: CDPhotos? = nil
    @Published var showingFilterViewSheet: Bool = false
    @Published var showingSettingsViewSheet: Bool = false
    @Published var showingOnlyFavorites: Bool = false
    @Published var isLoaded: Bool = false
    
    // Filters
    @Published var sorting: SortingTypes = .ascending
    @Published var sol: Int = 1000
    @Published var selectedDateType: DateTypes = .sol
    @Published var earthDate: Date = .now
    @Published var selectedCameraType: CameraName = .all
    
    init(rover: RoverType, dataService: JSONDataService){
        self.rover = rover
        self.dataService = dataService
        addSubscribers()
        dataService.getInformation(of: rover)
        dataService.getPhotosBySol(rover: rover, sol: sol, cameraType: .all, sortingType: .ascending)
    }
    
    func setup(coreDataService: CoreDataDataService, networkMonitor: NetworkMonitor){
        self.coreDataService = coreDataService
        favoritePhotos = coreDataService.accessPhotos(for: rover)
        self.networkMonitor = networkMonitor
        self.showingOnlyFavorites = true
        if networkMonitor.isConnected {
            self.showingOnlyFavorites = false
            networkMonitor.stopMonitoring()
        }
    }
    
    func filterImagesByEarthDate(_ date: Date, cameraType: CameraName, sortingType: SortingTypes){
        earthDate = date
        selectedDateType = .earthDate
        selectedCameraType = cameraType
        sorting = sortingType
        dataService.getPhotosByEarthDate(rover: rover, earthDate: date, cameraType: cameraType, sortingType: sortingType)
    }
    
    func filterImagesByMartianSol(_ martianSol: Int, cameraType: CameraName, sortingType: SortingTypes){
        sol = martianSol
        selectedDateType = .sol
        selectedCameraType = cameraType
        sorting = sortingType
        dataService.getPhotosBySol(rover: rover, sol: martianSol, cameraType: cameraType, sortingType: sortingType)
    }
    
    func filterImagesBySorting(_ sortingType: SortingTypes){
        sorting = sortingType
        
        switch sorting {
        case .ascending:
            roverImages.sort{ $0 < $1}
        case .descending:
            roverImages.sort{ $0 > $1}
        case .random:
            roverImages.shuffle()
        }
    }
    
    func addSubscribers() {
        dataService.$allPhotos
            .sink { [weak self] (returnedPhotos) in
                self?.roverImages = returnedPhotos
            }
            .store(in: &cancellables)
        
        dataService.$manifest
            .sink { [weak self] (returnedManifest) in
                self?.roverManifest = returnedManifest
            }
            .store(in: &cancellables)
    }
    
    func updateFavorites(){
        favoritePhotos = coreDataService.accessPhotos(for: rover)
    }
    
    func getLocalRoverManifestData() -> PhotoManifest? {
        dataService.loadManifestFromUserDefaults()
    }
}
