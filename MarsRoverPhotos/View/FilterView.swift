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
            .overlay(Button(action: {
                vm.applyFilter()
                dismiss()
            }, label: {
                Text("Apply Filter")
                    .foregroundColor(.white)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(RoundedRectangle(cornerRadius: 16).foregroundColor(.red))
                    .padding()
            })
                .opacity(vm.isAnythingChanges ? 1 : 0)
                .disabled(vm.isAnythingChanges ? false : true)
                     ,alignment: .bottom
            )
        }
    }
}

extension FilterView {
    
    private var ImageSortingSection: some View {
        Section(header: Text("Image Sorting")) {
            VStack(alignment: .leading) {
                Picker("", selection: $vm.sortingType) {
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
                Picker("", selection: $vm.selectedDateType) {
                    ForEach(DateTypes.allCases) { type in
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
}


struct FilterView_Previews: PreviewProvider {
    static var previews: some View {
        FilterView(roverVM: RoverViewModel(rover: .curiosity, dataService: .previewInstance))
    }
}
