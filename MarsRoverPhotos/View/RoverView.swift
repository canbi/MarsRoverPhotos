//
//  RoverView.swift
//  MarsRoverPhotos
//
//  Created by Can Bi on 20.06.2022.
//

import SwiftUI

struct RoverView: View {
    @StateObject var vm: RoverViewModel
    
    init(rover: RoverType, dataService: JSONDataService){
        self._vm = StateObject(wrappedValue: RoverViewModel(rover: rover,
                                                            dataService: dataService))
    }
    
    var body: some View {
        ScrollView {
            LazyVStack(spacing: 6, pinnedViews: .sectionHeaders) {
                PageHeader
                    .sheet(isPresented: $vm.showingSettingsViewSheet) {
                        SettingsView(tintColor: vm.rover.color)
                    }
                
                RoverImageView
                
                RoverInformationView
                
                Section(header: SectionHeader, footer: SectionFooter) {
                    ForEach(vm.roverImages, id: \.id) { photo in
                        ImageView(photo: photo, showCameraInfo: true)
                            .cornerRadius(16)
                            .frame(maxWidth: .infinity, minHeight: 250)
                            .onTapGesture { vm.selectedImage = photo }
                    }
                }
                .sheet(isPresented: $vm.showingFilterViewSheet) {
                    FilterView(roverVM: vm, tintColor: vm.rover.color)
                }
            }
            
            
            Spacer().frame(height: 100)
        }
        .navigationDestination(for: $vm.selectedImage) { photo in
            DetailView(photo: photo, manifest: vm.roverManifest!)
        }
    }
}

extension RoverView {
    private var PageHeader: some View {
        HStack {
            TitleView(vm.rover.rawValue)
            Spacer()
            Button {
                vm.showingSettingsViewSheet.toggle()
            } label: {
                Image(systemName: "gear")
                    .font(Font.title.weight(.bold))
                    .font(.largeTitle)
                    .tint(vm.rover.color)
                    .padding()
            }
        }
        .padding(.top, 44)
    }
    
    
    private func TitleView(_ title: String) -> some View {
        HStack {
            Text(title)
                .foregroundColor(vm.rover.color)
                .font(.largeTitle)
                .fontWeight(.heavy)
                .padding(.leading)
            Spacer()
        }
    }
    
    private func SubtitleView(_ subtitle: String) -> some View {
        HStack {
            Text(subtitle)
                .foregroundColor(vm.rover.color)
                .font(.body)
                .padding(.leading)
            Spacer()
        }
    }
    
    private var RoverImageView: some View {
        Image(vm.rover.rawValue.lowercased())
            .resizable()
            .scaledToFit()
            .frame(maxWidth: .infinity, maxHeight: 300)
            .padding(.leading)
    }
    
    private var RoverInformationView: some View {
        Group {
            if let roverManifest = vm.roverManifest {
                LazyVGrid(columns: [GridItem(.adaptive(minimum: 95), spacing: 10)]) {
                    GroupBox(label: Label("Max Sol", systemImage: "sun.max.fill").foregroundColor(vm.rover.color)) {
                        Text("\(String(roverManifest.maxSol))")
                    }
                    
                    GroupBox(label: Label("Max Date", systemImage: "calendar").foregroundColor(vm.rover.color)) {
                        Text("\(roverManifest.maxDate.formatted(.dateTime.day().month().year()))")
                    }
                    
                    GroupBox(label: Label("Total Photos", systemImage: "photo.on.rectangle.angled").foregroundColor(vm.rover.color)) {
                        Text("\(roverManifest.totalPhotos)")
                    }
                    
                    GroupBox(label: Label("Status", systemImage: "heart.fill").foregroundColor(vm.rover.color)) {
                        Text(roverManifest.status.capitalized)
                    }
                    
                    GroupBox(label: Label("Launch Date", systemImage: "airplane.departure").foregroundColor(vm.rover.color)) {
                        Text("\(roverManifest.launchDate.formatted(.dateTime.day().month().year()))")
                    }
                    
                    GroupBox(label: Label("Landing Date", systemImage: "airplane.arrival").foregroundColor(vm.rover.color)) {
                        Text("\(roverManifest.landingDate.formatted(.dateTime.day().month().year()))")
                    }
                }
                .groupBoxStyle(CardGroupBoxStyle())
                .padding(.horizontal)
            }
            else {
                ProgressView()
                    .frame(height:100)
            }
        }
    }
    
    private var SectionHeader: some View {
        VStack(alignment:.leading, spacing: 0) {
            HStack {
                TitleView("Photos")
                Spacer()
                Button {
                    vm.showingFilterViewSheet.toggle()
                } label: {
                    Image(systemName: "line.3.horizontal.circle")
                        .font(Font.title.weight(.bold))
                        .font(.largeTitle)
                        .tint(vm.rover.color)
                        .padding()
                }
            }
            Group {
                if !vm.roverImages.isEmpty {
                    Text(vm.selectedDateType == .sol ? "Sol \(String(vm.sol))" : "Earth Date \(vm.earthDate.formatted(.dateTime.day().month().year()))") + Text(", \(vm.selectedCameraType.rawValue),  \(vm.sorting.rawValue)")
                }
            }
            .font(.caption)
            .padding(.leading)
            .padding(.top, -10)
        }
        .padding(.top, 30)
        .padding(.bottom)
    }
    
    private var SectionFooter: some View {
        Group {
            if vm.roverImages.isEmpty && vm.isLoaded {
                VStack{
                    TitleView("Nothing")
                    SubtitleView("There are no available photos. Change filters to explore!")
                }
            } else if vm.isLoaded {
                VStack{
                    TitleView("Done")
                    SubtitleView("You have visited all the available photos. Change filters to explore!")
                }
            }
        }
        .onChange(of: vm.roverImages) { _ in
            vm.isLoaded = true
        }
    }
}

struct RoverView_Previews: PreviewProvider {
    static var previews: some View {
        RoverView(rover: .curiosity, dataService: .previewInstance)
    }
}
