//
//  ComicsView.swift
//  marvelapp
//
//  Created by Steven Spry on 3/12/25.
//

import SwiftUI

struct ThumbnailsView: View {

    var thumbnails:[CollectionThumbnail]
    var attribution:String
    let itemWidth = UIScreen.main.bounds.size.width / 3.0
    let columns = [GridItem(),GridItem(),GridItem()]

    var body: some View {
        ScrollView {
            Text(attribution)
                .font(.caption2)
                .multilineTextAlignment(.center)
                .frame(maxWidth: .infinity)
            
            VStack {
                LazyVGrid(columns:columns, spacing: 0) {
                    ForEach(thumbnails, id: \.id) { thumbnail in
                        ZStack {
                            ImageView(thumbnail.thumbnail) { image in
                                image
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: itemWidth, alignment: .center)
                            } placeholder: {
                                ProgressView()
                            }
                        }
                    }
                }
                .frame(maxWidth: .infinity)
            }
        }
    }
}

#Preview {
    EmptyView()
}
