//
//  ImageView.swift
//  marvelapp
//
//  Created by Steven Spry on 3/12/25.
//

import SwiftUI

public struct ImageView<Content: View, Placeholder: View>: View {
    @State var uiImage: UIImage?
    
    let thumbnail: Thumbnail
    let content: (Image) -> Content
    let placeholder: () -> Placeholder
    
    init(_ thumbnail: Thumbnail,
        @ViewBuilder content: @escaping (Image) -> Content,
        @ViewBuilder placeholder: @escaping () -> Placeholder
    ){
        self.thumbnail = thumbnail
        self.content = content
        self.placeholder = placeholder
    }
    
    public var body: some View {
        if let uiImage = uiImage {
            content(Image(uiImage: uiImage))
        } else {
            placeholder()
                .task {
                    self.uiImage = try? await MarvelService.shared.thumbnailImage(from: thumbnail)
                }
        }
    }
}
