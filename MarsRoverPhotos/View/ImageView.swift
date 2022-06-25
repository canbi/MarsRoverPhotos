//
//  ImageView.swift
//  MarsRoverPhotos
//
//  Created by Can Bi on 20.06.2022.
//

import SwiftUI

struct ImageView: View {
    @EnvironmentObject var settingManager: SettingManager
    @StateObject var vm: ImageViewModel
    
    var currentTintColor: Color { settingManager.getTintColor(roverType:vm.roverType) }
    
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
                        CustomGroupBoxMini(iconName: "camera",
                                           subtitle: vm.cameraName.rawValue,
                                           iconColor: currentTintColor)
                        .opacity(vm.showCameraInfo ? 0.9 : 0)
                        .padding([.bottom,.trailing])
                        , alignment: .bottomTrailing)
            } else {
                ProgressView()
                    .frame(maxWidth: .infinity)
                    .frame(height:200, alignment: .center)
            }
        }
    }
}

struct ImageView_Previews: PreviewProvider {
    static var previews: some View {
        ImageView(photo: .previewData)
    }
}
