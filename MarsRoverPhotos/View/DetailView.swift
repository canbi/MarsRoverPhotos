//
//  DetailView.swift
//  MarsRoverPhotos
//
//  Created by Can Bi on 21.06.2022.
//

import SwiftUI

struct DetailView: View {
    @StateObject var vm: DetailViewModel
    
    init(photo: Photo){
        self._vm = StateObject(wrappedValue: DetailViewModel(photo: photo))
    }
    
    var body: some View {
        ImageView(photo: vm.photo)
            .frame(maxWidth: .infinity)
    }
}

struct DetailView_Previews: PreviewProvider {
    static var previews: some View {
        DetailView(photo: .previewData)
    }
}
