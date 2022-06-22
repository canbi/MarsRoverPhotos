//
//  FilterViewModel.swift
//  MarsRoverPhotos
//
//  Created by Can Bi on 21.06.2022.
//

import Foundation

class FilterViewModel: ObservableObject {
    var roverVM: RoverViewModel
    
    var maximumSol: Int { roverVM.roverManifest?.maxSol ?? 1000 }
    var startingDate: Date { roverVM.roverManifest?.landingDate ?? Date.now}
    var lastDate: Date { roverVM.roverManifest?.maxDate ?? Date.now}
    
    @Published var martianSol: Int { didSet { isAnythingChanges = true }}
    @Published var earthDate: Date { didSet { isAnythingChanges = true }}
    @Published var sortingType: SortingTypes { didSet { isAnythingChanges = true }}
    @Published var selectedDateType: DateTypes { didSet { isAnythingChanges = true }}
    
    @Published var isAnythingChanges: Bool = false
    
    init(roverVM: RoverViewModel){
        self.roverVM = roverVM
        self._martianSol = Published(initialValue: roverVM.sol)
        self._earthDate = Published(initialValue: roverVM.earthDate)
        self._sortingType = Published(initialValue: roverVM.sorting)
        self._selectedDateType = Published(initialValue: roverVM.selectedDateType)
    }
    
    func applyFilter(){
        if selectedDateType == .earthDate {
            if earthDate != roverVM.earthDate {
                roverVM.filterImagesByEarthDate(earthDate)
            }
            else {
                roverVM.selectedDateType = .earthDate
            }
        } else if selectedDateType == .sol {
            if martianSol != roverVM.sol {
                roverVM.filterImagesByMartianSol(martianSol)
            } else {
                roverVM.selectedDateType = .sol
            }
        }
        
        if sortingType != roverVM.sorting || sortingType == .random {
            roverVM.filterImagesBySorting(sortingType)
        }
    }
}
