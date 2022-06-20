//
//  RoverView.swift
//  MarsRoverPhotos
//
//  Created by Can Bi on 20.06.2022.
//

import SwiftUI

struct RoverView: View {
    @ObservedObject var vm: RoverViewModel = RoverViewModel(rover: .curiosity)
    
    var body: some View {
        List {
            ForEach(vm.roverImages, id: \.id) { image in
                Text(image.camera.fullName.rawValue)
            }
        }
    }
}

struct RoverView_Previews: PreviewProvider {
    static var previews: some View {
        RoverView()
    }
}
