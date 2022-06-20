//
//  ImageView.swift
//  MarsRoverPhotos
//
//  Created by Can Bi on 20.06.2022.
//

import SwiftUI

struct ImageView: View {
    @StateObject var vm: ImageViewModel
    var photo: Photo
    
    init(photo: Photo) {
        self.photo = photo
        self._vm = StateObject(wrappedValue: ImageViewModel(photo: photo))
    }
    
    var body: some View {
        if let image = vm.image {
            Image(uiImage: image)
                .resizable()
                .scaledToFit()
        } else if vm.isLoading {
            ProgressView()
        } else {
            Image(systemName: "questionmark")
                .foregroundColor(.primary)
        }
    }
}

struct ImageView_Previews: PreviewProvider {
    static var previews: some View {
        ImageView(photo: .previewData)
    }
}
