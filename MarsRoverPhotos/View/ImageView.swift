//
//  ImageView.swift
//  MarsRoverPhotos
//
//  Created by Can Bi on 20.06.2022.
//

import SwiftUI

struct ImageView: View {
    @StateObject var vm: ImageViewModel
    
    init(photo: Photo, showCameraInfo: Bool = false) {
        self._vm = StateObject(wrappedValue: ImageViewModel(photo: photo, showCameraInfo: showCameraInfo))
    }
    
    var body: some View {
        Group {
            if let image = vm.image {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFit()
                    .overlay(
                        GroupBox(label: Label("Camera", systemImage: "camera").foregroundColor(vm.roverType.color)) {
                            Text(vm.cameraName.rawValue)
                        }
                        .opacity(vm.showCameraInfo ? 0.9 : 0)
                        .groupBoxStyle(CardGroupBoxStyle())
                        .padding([.bottom,.trailing])
                        , alignment: .bottomTrailing)
            } else if vm.isLoading {
                ProgressView()
            } else {
                Image(systemName: "questionmark")
                    .foregroundColor(.primary)
            }
        }
    }
}

struct ImageView_Previews: PreviewProvider {
    static var previews: some View {
        ImageView(photo: .previewData)
    }
}
