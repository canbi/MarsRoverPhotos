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
    
    init(roverVM: RoverViewModel){
        self.roverVM = roverVM
    }
}
