//
//  ImageZoomView.swift
//  MarsRoverPhotos
//
//  Created by Can Bi on 21.06.2022.
//

import UIKit
import SwiftUI
import PDFKit

//https://stackoverflow.com/a/67577296
struct PhotoDetailView: UIViewRepresentable {
    let image: UIImage

    func makeUIView(context: Context) -> PDFView {
        let view = PDFView()
        view.document = PDFDocument()
        guard let page = PDFPage(image: image) else { return view }
        view.document?.insert(page, at: 0)
        view.autoScales = true
        return view
    }

    func updateUIView(_ uiView: PDFView, context: Context) {
        // empty
    }
}

struct ImageZoomView: View {
    @Environment(\.dismiss) var dismiss
    var image: UIImage
    
    var body: some View {
        PhotoDetailView(image: image)
            .ignoresSafeArea()
            .overlay(BackButton { dismiss() }, alignment: .topLeading)
    }
}
