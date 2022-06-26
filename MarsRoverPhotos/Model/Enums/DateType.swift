//
//  DateType.swift
//  MarsRoverPhotos
//
//  Created by Can Bi on 26.06.2022.
//

import Foundation

enum DateType: String, CaseIterable, Identifiable {
    case sol = "Martian Sol"
    case earthDate = "Earth Date"
    
    var id: Self { self }
}
