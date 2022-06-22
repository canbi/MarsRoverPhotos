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
    
    init(roverVM: RoverViewModel){
        self._vm = StateObject(wrappedValue: FilterViewModel(roverVM: roverVM))
    }
    
    var body: some View {
        NavigationView {
            List {
                ImageSortingSection
                DateSection
            }
            .font(.headline)
            .accentColor(.blue)
            .listStyle(GroupedListStyle())
            .navigationTitle("Settings")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    BackButton { dismiss() }
                    .padding(.leading, -24)
                }
            }
        }
    }
}

extension FilterView {
    
    private var ImageSortingSection: some View {
        Section(header: Text("Image Sorting")) {
            VStack(alignment: .leading) {
                Picker("", selection: $vm.roverVM.sorting) {
                    ForEach(SortingTypes.allCases) { type in
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
        Section(header: Text("Date Filter")) {
            VStack(alignment: .leading) {
                Picker("", selection: $vm.roverVM.selectedDateType) {
                    ForEach(DateTypes.allCases) { type in
                        Text(type.rawValue)
                    }
                }
                .labelsHidden()
                .pickerStyle(.segmented)
                
                Spacer().frame(height: 15)
                
                HStack {
                    if vm.roverVM.selectedDateType == .sol {
                        Slider(value: IntDoubleBinding($vm.roverVM.sol).doubleValue, in: 0...Double(vm.maximumSol), step: 1.0)
                        Text(String(vm.roverVM.sol) + " Sol")
                            .padding(8)
                            .background(Color(UIColor.tertiarySystemBackground))
                            .cornerRadius(12)
                    }
                    else {
                        Text("Select a date")
                        DatePicker(selection: $vm.roverVM.earthDate, in: vm.startingDate...vm.lastDate, displayedComponents: .date){}
                        
                    }
                }
            }
            .padding(.vertical)
        }
    }
}


struct FilterView_Previews: PreviewProvider {
    static var previews: some View {
        FilterView(roverVM: RoverViewModel(rover: .curiosity, dataService: .previewInstance))
    }
}
