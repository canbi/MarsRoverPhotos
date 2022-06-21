//
//  BackButton.swift
//  MarsRoverPhotos
//
//  Created by Can Bi on 21.06.2022.
//

import SwiftUI

struct BackButton: View {
    var action: () -> Void
    
    init(action: @escaping () -> Void) {
        self.action = action
    }
    
    var body: some View {
        Button {
            action()
        } label: {
            HStack{
                Image(systemName: "chevron.left")
                    .font(.headline)
                    
                Text("Back")
            }
            .padding(12)
            .foregroundColor(.white)
            .background(.red)
            .cornerRadius(16)
            .padding()
            .scaleEffect(0.8)
        }
    }
}

struct BackButton_Previews: PreviewProvider {
    static var previews: some View {
        BackButton {
            print("hello")
        }
    }
}
