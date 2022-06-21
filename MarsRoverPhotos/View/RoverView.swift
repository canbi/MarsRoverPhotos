//
//  RoverView.swift
//  MarsRoverPhotos
//
//  Created by Can Bi on 20.06.2022.
//

import SwiftUI

struct RoverView: View {
    @StateObject var vm: RoverViewModel = RoverViewModel(rover: .curiosity)
    
    var body: some View {
        ScrollView {
            LazyVStack {
                ForEach(vm.roverImages, id: \.id) { photo in
                    ImageView(photo: photo)
                        .frame(maxWidth: .infinity, minHeight: 300)
                        .onTapGesture { vm.selectedImage = photo }
                        .cornerRadius(16)
                }
            }
        }
        .navigationDestination(for: $vm.selectedImage) { photo in
            DetailView(photo: photo)
        }
    }
}

struct RoverView_Previews: PreviewProvider {
    static var previews: some View {
        RoverView()
    }
}
