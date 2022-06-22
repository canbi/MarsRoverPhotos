//
//  RoverViewModel.swift
//  MarsRoverPhotos
//
//  Created by Can Bi on 20.06.2022.
//

import Combine
import Foundation

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
    
    // Data
    private var dataService: JSONDataService
    @Published var roverImages: [Photo] = [] {
        didSet {
            earthDate = roverImages.first?.earthDate ?? Date.now
            sol = roverImages.first?.sol ?? 1000
        }
    }
    @Published var roverManifest: PhotoManifest?
    private var cancellables = Set<AnyCancellable>()
    
    // Controls
    @Published var selectedImage: Photo? = nil
    @Published var showingFilterViewSheet: Bool = false
    
    // Filters
    @Published var sorting: SortingTypes = .ascending
    @Published var sol: Int = 1000
    @Published var selectedDateType: DateTypes = .sol
    @Published var earthDate: Date = .now
    
    
    init(rover: RoverType, dataService: JSONDataService){
        self.rover = rover
        self.dataService = dataService
        addSubscribers()
        dataService.getInformation(of: rover)
        dataService.getPhotosBySol(rover: rover, sol: sol)
    }
    
    func filterImagesByEarthDate(_ date: Date){
        earthDate = date
        selectedDateType = .earthDate
        dataService.getPhotosByEarthDate(rover: rover, earthDate: date)
    }
    
    func filterImagesByMartianSol(_ martianSol: Int){
        sol = martianSol
        selectedDateType = .sol
        dataService.getPhotosBySol(rover: rover, sol: martianSol)
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
}
