//
//  FilterView.swift
//  MarsRoverPhotos
//
//  Created by Can Bi on 21.06.2022.
//

import Combine
import SwiftUI

struct FilterView: View {
    @StateObject var vm: FilterViewModel
    @Environment(\.dismiss) var dismiss
    
    let tintColor: Color
    
    init(roverVM: RoverViewModel, tintColor: Color){
        self.tintColor = tintColor
        self._vm = StateObject(wrappedValue: FilterViewModel(roverVM: roverVM))
        
        UITableView.appearance().contentInset.top = -20
        UINavigationBar.appearance().largeTitleTextAttributes = [.foregroundColor: UIColor(tintColor)]
        UINavigationBar.appearance().titleTextAttributes = [.foregroundColor: UIColor(tintColor)]
    }
    
    var body: some View {
        NavigationView {
            List {
                ImageSortingSection
                DateSection
                CameraSection
                Color.clear.listRowBackground(Color.clear)
            }
            .font(.headline)
            .accentColor(tintColor)
            .listStyle(.automatic)
            .navigationTitle("Filters")
            .navigationBarHidden(false)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    BackButton(color: tintColor) { dismiss() }
                        .padding(.leading, -24)
                }
            }
            .overlay(ApplyFilterButton, alignment: .bottom)
        }
    }
}

// MARK: Button
extension FilterView {
    private var ApplyFilterButton: some View {
        Button(action: {
            vm.applyFilter()
            dismiss()
        }, label: {
            Text("Apply Filter")
                .foregroundColor(.white)
                .padding()
                .frame(maxWidth: .infinity)
                .background(RoundedRectangle(cornerRadius: 16).foregroundColor(tintColor))
                .padding()
        })
        .opacity(vm.isAnythingChanged ? 1 : 0)
        .disabled(vm.isAnythingChanged ? false : true)
    }
}

// MARK: Sections
extension FilterView {
    private var ImageSortingSection: some View {
        Section(header: Text("Image Sorting".uppercased())) {
            VStack(alignment: .leading) {
                Picker("", selection: $vm.sortingType) {
                    ForEach(SortingType.allCases) { type in
                        Text(type.rawValue)
                    }
                }
                .labelsHidden()
                .pickerStyle(.segmented)
            }
            .padding(.vertical)
        }
    }
    
    private var DateSection: some View {
        Section(header: Text("Date Filter".uppercased())) {
            VStack(alignment: .leading) {
                Picker("", selection: $vm.selectedDateType) {
                    ForEach(DateType.allCases) { type in
                        Text(type.rawValue)
                    }
                }
                .labelsHidden()
                .pickerStyle(.segmented)
                
                Spacer().frame(height: 15)
                
                HStack {
                    if vm.selectedDateType == .sol {
                        Slider(value: IntDoubleBinding($vm.martianSol).doubleValue, in: 0...Double(vm.maximumSol), step: 1.0)
                        Text(String(vm.martianSol) + " Sol")
                            .padding(8)
                            .background(Color(UIColor.tertiarySystemBackground))
                            .cornerRadius(12)
                    }
                    else {
                        Text("Select a date")
                        DatePicker(selection: $vm.earthDate, in: vm.startingDate...vm.lastDate, displayedComponents: .date){}
                        
                    }
                }
            }
            .padding(.vertical)
        }
    }
    
    private var CameraSection: some View {
        Section(header: Text("Camera Filter".uppercased())) {
            Picker("Camera Type", selection: $vm.selectedCameraType) {
                ForEach(vm.roverVM.rover.cameraAvability) { type in
                    Text(type.rawValue)
                }
            }
            .labelsHidden()
            .pickerStyle(.inline)
        }
    }
}

// MARK: - Preview
struct FilterView_Previews: PreviewProvider {
    static var previews: some View {
        FilterView(roverVM: RoverViewModel(rover: .curiosity,
                                           dataService: .previewInstance),
                   tintColor: .red)
    }
}
