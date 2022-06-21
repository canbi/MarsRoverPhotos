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
                ForEach(vm.roverImages, id: \.id) { image in
                    ImageView(photo: image)
                        .frame(width: 200, height: 200)
                        .onTapGesture {
                            segue(photo: image)
                        }
                }
            }
        }
        .background{
            NavigationLink(isActive: $vm.showDetailView) {
                Text("Destination")
            } label: { EmptyView() }
        }
    }
    
    private func segue(photo: Photo) {
        vm.selectedImage = photo
        vm.showDetailView.toggle()
    }
}

struct RoverView_Previews: PreviewProvider {
    static var previews: some View {
        RoverView()
    }
}
