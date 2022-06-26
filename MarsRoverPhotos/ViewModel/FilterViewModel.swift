//
//  FilterViewModel.swift
//  MarsRoverPhotos
//
//  Created by Can Bi on 21.06.2022.
//

import Foundation

class FilterViewModel: ObservableObject {
    var roverVM: RoverViewModel
    
    // Rules
    var maximumSol: Int { roverVM.roverManifest?.maxSol ?? 1000 }
    var startingDate: Date { roverVM.roverManifest?.landingDate ?? Date.now}
    var lastDate: Date { roverVM.roverManifest?.maxDate ?? Date.now}
    
    // Filters
    @Published var martianSol: Int
    @Published var earthDate: Date
    @Published var sortingType: SortingType
    @Published var selectedDateType: DateType
    @Published var selectedCameraType:  CameraName
    
    // Control
    var isAnythingChanged: Bool { !isSortingSame || !isDateFilterSame || !isCameraTypeSame }
    var isSortingSame: Bool { sortingType == roverVM.sorting }
    var isDateFilterSame: Bool { martianSol == roverVM.sol && earthDate == roverVM.earthDate }
    var isCameraTypeSame: Bool { selectedCameraType == roverVM.selectedCameraType }
    
    init(roverVM: RoverViewModel){
        self.roverVM = roverVM
        self._martianSol = Published(initialValue: roverVM.sol)
        self._earthDate = Published(initialValue: roverVM.earthDate)
        self._sortingType = Published(initialValue: roverVM.sorting)
        self._selectedDateType = Published(initialValue: roverVM.selectedDateType)
        self._selectedCameraType = Published(initialValue: roverVM.selectedCameraType)
    }
    
    func applyFilter(){
        guard isAnythingChanged else {return}
        
        guard !isDateFilterSame || !isCameraTypeSame else {
            print("sadece sorting yapıldı")
            roverVM.filterImagesBySorting(sortingType)
            return
        }
        
        if selectedDateType == .earthDate {
            roverVM.filterImagesByEarthDate(earthDate, cameraType: selectedCameraType, sortingType: sortingType)
        } else if selectedDateType == .sol {
            roverVM.filterImagesByMartianSol(martianSol, cameraType: selectedCameraType, sortingType: sortingType)
        }
    }
}
