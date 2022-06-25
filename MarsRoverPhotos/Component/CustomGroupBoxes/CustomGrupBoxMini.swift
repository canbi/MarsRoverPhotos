//
//  CustomGrupBoxMini.swift
//  MarsRoverPhotos
//
//  Created by Can Bi on 25.06.2022.
//

import SwiftUI

struct CustomGroupBoxMini: View {
    var iconName: String
    var subtitle: String?
    var iconColor: Color
    
    var body: some View {
        HStack(spacing: 2){
            Image(systemName: iconName)
                .foregroundColor(iconColor)
            Text(subtitle ?? "")
        }
        .font(.caption)
        .padding([.leading,.vertical], 8)
        .padding(.trailing, 6)
        .background(Color(UIColor.secondarySystemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
    }
}
