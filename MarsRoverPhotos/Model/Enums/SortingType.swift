//
//  SortingTypes.swift
//  MarsRoverPhotos
//
//  Created by Can Bi on 26.06.2022.
//

import Foundation

enum SortingType: String,CaseIterable, Identifiable {
    case ascending = "Ascending"
    case descending = "Descending"
    case random = "Random"
    
    var id: Self { self }
}
