//
//  FilterViewModel.swift
//  MarsRoverPhotos
//
//  Created by Can Bi on 21.06.2022.
//

import Foundation

class FilterViewModel: ObservableObject {
    var roverVM: RoverViewModel
    
    init(roverVM: RoverViewModel){
        self.roverVM = roverVM
    }
}
