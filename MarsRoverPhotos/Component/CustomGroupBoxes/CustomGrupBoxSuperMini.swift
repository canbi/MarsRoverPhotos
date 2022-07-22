//
//  CustomGrupBoxSuperMini.swift
//  MarsRoverPhotos
//
//  Created by Can Bi on 22.07.2022.
//

import SwiftUI

struct CustomGroupBoxSuperMini: View {
    var iconName: String
    var subtitle: String?
    var iconColor: Color
    
    var body: some View {
        HStack(spacing: 2){
            Image(systemName: iconName)
                .foregroundColor(iconColor)
            Text(subtitle ?? "")
        }
        .font(.caption2)
        .padding([.horizontal,.vertical], 6)
        .background(Color(UIColor.secondarySystemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
    }
}
