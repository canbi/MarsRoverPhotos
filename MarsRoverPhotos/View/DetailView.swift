//
//  DetailView.swift
//  MarsRoverPhotos
//
//  Created by Can Bi on 21.06.2022.
//

import SwiftUI

struct DetailView: View {
    @StateObject var vm: DetailViewModel
    @Environment(\.dismiss) var dismiss
    
    init(photo: Photo){
        self._vm = StateObject(wrappedValue: DetailViewModel(photo: photo))
    }
    
    var body: some View {
        VStack(spacing: 0){
            ImageView(photo: vm.photo)
                .frame(maxWidth: .infinity)
                .overlay(alignment: .bottomTrailing) {
                    ZoomButton(action: vm.getImage)
                }
                .sheet(isPresented: $vm.showingZoomImageView, content: {
                    ImageZoomView(image: vm.clickedImage!)
                })
                .overlay(alignment: .topLeading) {
                    BackButton { dismiss() }
                        .padding(.top, 24)
                }
            Spacer()
            
        }
        .navigationBarBackButtonHidden(true)
        .navigationBarHidden(true)
        .navigationTitle("")
        .ignoresSafeArea()
    }
}

struct DetailView_Previews: PreviewProvider {
    static var previews: some View {
        DetailView(photo: .previewData)
    }
}
