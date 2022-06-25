//
//  ImageOfflineView.swift
//  MarsRoverPhotos
//
//  Created by Can Bi on 25.06.2022.
//

import SwiftUI

struct ImageOfflineView: View {
    @EnvironmentObject var settingManager: SettingManager
    @StateObject var vm: ImageOfflineViewModel
    
    var currentTintColor: Color { settingManager.getTintColor(roverType: vm.roverType) }
    
    
    init(photo: CDPhotos, showCameraInfo: Bool = false){
        self._vm = StateObject(wrappedValue: ImageOfflineViewModel(photo: photo, showCameraInfo: showCameraInfo))
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
                        .padding([.bottom,.trailing], 6)
                        , alignment: .bottomTrailing)
            } else {
                ProgressView()
                    .frame(maxWidth: .infinity)
                    .frame(height:200, alignment: .center)
            }
        }
    }
}

struct ImageOfflineView_Previews: PreviewProvider {
    static var previews: some View {
        ImageOfflineView(photo: CDPhotos())
    }
}
