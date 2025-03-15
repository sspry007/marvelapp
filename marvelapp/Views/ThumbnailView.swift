//
//  ComicsView.swift
//  marvelapp
//
//  Created by Steven Spry on 3/12/25.
//

import SwiftUI

struct ThumbnailsView: View {

    var thumbnails:[CollectionThumbnail]
    let itemWidth = UIScreen.main.bounds.size.width / 3.0
    
    let columns = [
        GridItem(),
        GridItem(),
        GridItem(),
    ]

    var body: some View {
        ScrollView {
            VStack {
                Text(String(thumbnails.count))
                LazyVGrid(columns:columns, spacing: 0) {
                    ForEach(thumbnails, id: \.id) { thumbnail in
                        ZStack {
                            Text(thumbnail.title)
                            ImageView(thumbnail.thumbnail.urlString) { image in
                                image
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: itemWidth, height: itemWidth, alignment: .center)
                                    .clipped()
                                    .contentShape(Rectangle())
                                    .background(.red)
                            } placeholder: {
                                ProgressView()
                            }
                        }
                        
                    }
                }
                .frame(maxWidth: .infinity)

            }

        }
        .onAppear {
            Task {
                do {
                    //viewModel.loadComics(character:character)
                    //let success = try await MarvelService.shared.characters()
                    
                } catch {
                    print("catch")
                }
            }
        }
    }
}

#Preview {
    //ComicsView(character:Character.mock())
    EmptyView()
}
