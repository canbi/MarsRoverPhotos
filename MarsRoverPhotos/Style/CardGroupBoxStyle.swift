//
//  CardBoxPlainStyle.swift
//  MarsRoverPhotos
//
//  Created by Can Bi on 21.06.2022.
//

import SwiftUI

struct CardGroupBoxStyle: GroupBoxStyle {
    func makeBody(configuration: Configuration) -> some View {
        VStack(spacing: 2) {
            configuration.label
                .foregroundColor(.red)
            configuration.content
        }
        .frame(minWidth: 100)
        .fixedSize(horizontal: true, vertical: true)
        .font(.caption)
        .padding(8)
        .background(Color(UIColor.secondarySystemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
    }
}
