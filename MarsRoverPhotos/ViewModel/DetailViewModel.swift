//
//  DetailViewModel.swift
//  MarsRoverPhotos
//
//  Created by Can Bi on 21.06.2022.
//

import Combine
import Foundation
import UIKit

class DetailViewModel: ObservableObject {
    let photo: Photo
    
    init(photo: Photo){
        self.photo = photo
    }
}
