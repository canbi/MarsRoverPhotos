//
//  RoverView.swift
//  MarsRoverPhotos
//
//  Created by Can Bi on 20.06.2022.
//

import SwiftUI

struct RoverView: View {
    @EnvironmentObject var coreDataService: CoreDataDataService
    @EnvironmentObject var settingManager: SettingManager
    @StateObject var vm: RoverViewModel
    
    var currentTintColor: Color { settingManager.getTintColor(roverType: vm.rover)}
    
    init(rover: RoverType, shouldScroolToTop: Binding<Bool>, dataService: JSONDataService){
        self._vm = StateObject(wrappedValue: RoverViewModel(rover: rover,
                                                            shouldScrollToTop: shouldScroolToTop,
                                                            dataService: dataService))
    }
    
    var body: some View {
        ScrollViewReader { reader in
            ScrollView {
                LazyVStack(spacing: 6, pinnedViews: .sectionHeaders) {
                    PageHeader
                        .sheet(isPresented: $vm.showingSettingsViewSheet) {
                            SettingsView(tintColor: currentTintColor)
                        }
                        .onAppear{
                            vm.setup(coreDataService: coreDataService)
                        }
                    
                    RoverImageView
                    
                    RoverInformationView
                    
                    ImageSectionView
                    .sheet(isPresented: $vm.showingFilterViewSheet) {
                        FilterView(roverVM: vm, tintColor: currentTintColor)
                    }
                }
                
                Spacer().frame(height: 100)
            }
            .navigationDestination(for: $vm.selectedImage) { photo in
                DetailView(photo: photo, manifest: vm.roverManifest!, roverVM: vm)
            }
            .navigationDestination(for: $vm.selectedOfflineImage) { photo in
                DetailView(cdPhoto: photo, manifest: vm.roverManifest!, roverVM: vm)
            }
            .onChange(of: vm.shouldScrollToTop) { _ in
                withAnimation {
                   reader.scrollTo("top", anchor: .top)
                    vm.shouldScrollToTop = false
                }
            }
        }
    }
}

//MARK: Image
extension RoverView {
    private var ImageSectionView: some View {
        Section(header: SectionHeader, footer: SectionFooter) {
            if vm.roverImages.isEmpty && !vm.isLoaded {
                RoundedRectangle(cornerRadius: 16)
                    .foregroundColor(Color(UIColor.secondarySystemBackground))
                    .frame(height:300)
                    .frame(maxWidth: .infinity)
                    .padding([.horizontal])
                    .redacted(reason: .placeholder)
            }
            
            let oneColumns = [GridItem(.flexible(maximum: .infinity))]
            let twoColumns = [GridItem(.flexible(maximum: .infinity)),
                              GridItem(.flexible(maximum: .infinity))]
            
            LazyVGrid(columns: settingManager.gridDesign == .oneColumn ? oneColumns : twoColumns,
                      alignment: .leading, spacing: 10) {
                
                if vm.showingOnlyFavorites {
                    ForEach(vm.favoritePhotos, id: \.wrappedId) { photo in
                        ImageOfflineView(photo: photo, showCameraInfo: true)
                            .overlay(Image(systemName: "heart.fill")
                                .foregroundColor(.red)
                                .imageScale(settingManager.gridDesign == .oneColumn ? .large : .medium)
                                .padding([.top,.trailing], 6),
                                     alignment: .topTrailing)
                            .cornerRadius(16)
                            .onTapGesture { vm.selectedOfflineImage = photo }
                    }
                }
                else {
                    ForEach(vm.roverImages, id: \.id) { photo in
                        ImageView(photo: photo, showCameraInfo: true)
                            .overlay(Image(systemName: "heart.fill")
                                .foregroundColor(.red)
                                .imageScale(settingManager.gridDesign == .oneColumn ? .large : .medium)
                                .opacity(coreDataService.isFavorited(in: vm.favoritePhotos, id: photo.id) ? 1 : 0)
                                .padding([.top,.trailing], 6),
                                     alignment: .topTrailing)
                            .cornerRadius(16)
                            .onTapGesture { vm.selectedImage = photo }
                    }
                }
            }
            .padding(.horizontal)
            .animation(.easeInOut, value: settingManager.gridDesign)
        }
    }
    
    private var RoverImageView: some View {
        Image(vm.rover.rawValue.lowercased())
            .resizable()
            .scaledToFit()
            .frame(maxWidth: .infinity, maxHeight: 300)
            .padding(.leading)
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
                    .font(.title)
                    .tint(currentTintColor)
                    .padding()
            }
        }
        .padding(.top, 44)
        .id("top")
    }
    
    private func TitleView(_ title: String) -> some View {
        HStack {
            Text(title)
                .foregroundColor(currentTintColor)
                .font(.largeTitle)
                .fontWeight(.bold)
                .padding(.leading)
            Spacer()
        }
    }
    
    private func SubtitleView(_ subtitle: String) -> some View {
        HStack {
            Text(subtitle)
                .foregroundColor(currentTintColor)
                .font(.body)
                .padding(.leading)
            Spacer()
        }
    }
    
    private var RoverInformationView: some View {
        Group {
            LazyVGrid(columns: [GridItem(.adaptive(minimum: 95), spacing: 10)]) {
                CustomGroupBox(iconName: "sun.max.fill",
                               title: "Max Sol",
                               subtitle: String(vm.roverManifest?.maxSol ?? 0),
                               titleColor: currentTintColor)
                
                CustomGroupBox(iconName: "calendar",
                               title: "Max Date",
                               subtitle: "\(vm.roverManifest?.maxDate.formatted(.dateTime.day().month().year()) ?? "")",
                               titleColor: currentTintColor)
                
                CustomGroupBox(iconName: "photo.on.rectangle.angled",
                               title: "Total Photos",
                               subtitle: String(vm.roverManifest?.totalPhotos ?? 0),
                               titleColor: currentTintColor)
                
                CustomGroupBox(iconName: "heart.fill",
                               title: "Status",
                               subtitle: vm.roverManifest?.status.capitalized,
                               titleColor: currentTintColor)
                
                CustomGroupBox(iconName: "airplane.departure",
                               title: "Launch Date",
                               subtitle: "\(vm.roverManifest?.launchDate.formatted(.dateTime.day().month().year()) ?? "")",
                               titleColor: currentTintColor)
                
                CustomGroupBox(iconName: "airplane.arrival",
                               title: "Landing Date",
                               subtitle: "\(vm.roverManifest?.landingDate.formatted(.dateTime.day().month().year()) ?? "")",
                               titleColor: currentTintColor)
            }
            .padding(.horizontal)
        }
        .redacted(reason: vm.roverManifest == nil ? .placeholder : [])
    }
    
    private var SectionHeader: some View {
        VStack(alignment:.leading, spacing: 0) {
            HStack(spacing: 0) {
                TitleView("Photos")
                
                Spacer()
                
                Button {
                    vm.showingOnlyFavorites.toggle()
                } label: {
                    Image(systemName: vm.showingOnlyFavorites ? "heart.fill" : "heart")
                        .font(.title)
                        .tint(currentTintColor)
                        .padding(.vertical)
                        .padding(.horizontal, 8)
                }
                
                Button {
                    settingManager.changeGrid()
                } label: {
                    Image(systemName: settingManager.gridDesign == .oneColumn ? "rectangle.grid.2x2" : "rectangle.grid.1x2")
                        .font(.title)
                        .tint(currentTintColor)
                        .padding(.vertical)
                        .padding(.horizontal, 8)
                }
                
                Button {
                    vm.showingFilterViewSheet.toggle()
                } label: {
                    Image(systemName: "line.3.horizontal.decrease.circle")
                        .font(.title)
                        .tint(currentTintColor)
                        .padding(.vertical)
                        .padding(.horizontal, 8)
                }
            }
            Group {
                if !vm.roverImages.isEmpty {
                    Group{
                        Text(vm.selectedDateType == .sol ? "Sol \(String(vm.sol))" : "Earth Date \(vm.earthDate.formatted(.dateTime.day().month().year()))") + Text(", \(vm.selectedCameraType.rawValue),  \(vm.sorting.rawValue)")
                    }
                    .padding(.horizontal,6)
                    .padding(.vertical,4)
                    .background(
                        RoundedRectangle(cornerRadius: 6)
                            .fill(Color(UIColor.secondarySystemBackground))
                    )
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
        RoverView(rover: .curiosity, shouldScroolToTop: .constant(false), dataService: .previewInstance)
    }
}
