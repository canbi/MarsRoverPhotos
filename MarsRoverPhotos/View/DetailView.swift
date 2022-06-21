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
            
            Spacer().frame(height: 20)

            PhotoInformationView
            
            Spacer()
        }
        .navigationBarBackButtonHidden(true)
        .navigationBarHidden(true)
        .navigationTitle("")
        .ignoresSafeArea()
    }
}

extension DetailView {
    private var PhotoInformationView: some View {
        LazyVGrid(columns: [GridItem(.adaptive(minimum: 100), alignment: .top)]) {
            GroupBox(label: Label("Rover", systemImage: "sun.max.fill")) {
                Text(vm.photo.rover.name.rawValue)
            }
            
            GroupBox(label: Label("Rover Status", systemImage: "calendar")) {
                Text(vm.photo.rover.status.capitalized)
            }
            
            GroupBox(label: Label("Taken Sol", systemImage: "calendar")) {
                Text("\(vm.photo.sol)")
            }
            
            GroupBox(label: Label("Taken Earth Date", systemImage: "calendar")) {
                Text(vm.photo.earthDate)
            }
            
            GroupBox(label: Label("Camera Code", systemImage: "calendar")) {
                Text(vm.photo.camera.name.rawValue)
            }
            
            GroupBox(label: Label("Camera Name", systemImage: "calendar")) {
                Text(vm.photo.camera.fullName.rawValue)
            }
        }
        .groupBoxStyle(CardGroupBoxStyle())
        .padding(.horizontal)
    }
}

struct DetailView_Previews: PreviewProvider {
    static var previews: some View {
        DetailView(photo: .previewData)
    }
}
