//
//  CharacterDetailView.swift
//  marvelapp
//
//  Created by Steven Spry on 3/12/25.
//

import SwiftUI

struct CharacterDetailView: View {
    @StateObject var viewModel = CharacterDetailViewModel()

    @State private var comicButtonTapped = true
    @State private var eventButtonTapped = false
    var character:Character

    var body: some View {
        VStack(alignment: .leading) {
            VStack {
                HStack(alignment: .center) {
                    Text(character.name)
                        .font(.title).bold()
                    Spacer()
                    ImageView(character.thumbnail) { image in
                        image
                            .resizable()
                            .scaledToFit()
                            .frame(width: 75, height: 75, alignment: .center)
                            .clipShape(RoundedRectangle(cornerRadius: 37.5, style: .continuous))
                        
                    } placeholder: {
                        ProgressView()
                    }
                }
                .frame(maxWidth: .infinity, alignment: .topLeading)
                
                Text(character.description.truncate(to: 100, ellipsis: true))
                    .padding([.top], 25)
                    .padding([.bottom], 25)
            }
            .padding([.leading,.trailing], 30)
            .padding([.top,.bottom], 20)
            
            if viewModel.isLoading {
                HStack(alignment: .top, spacing: 0) {
                    ProgressView("Loading Comics and Events...")
                }
                .frame(maxWidth: .infinity)
                Spacer()
            }
            else {
                Spacer()
                HStack(alignment: .top, spacing: 0) {
                    Button {
                        self.comicButtonTapped = true
                        self.eventButtonTapped = false
                    } label: {
                        VStack(alignment: .center) {
                            Image(systemName: "book")
                                .resizable()
                                .frame(width: 24.0, height: 24.0)
                            Text(String(viewModel.comicThumbnails.count))
                        }
                    }
                    .tint(comicButtonTapped ? Color.black : Color(UIColor.lightGray))
                    .frame(maxWidth: .infinity)
                    
                    Spacer()
                    Button {
                        self.eventButtonTapped = true
                        self.comicButtonTapped = false
                    } label: {
                        VStack(alignment: .center) {
                            Image(systemName: "tv")
                                .resizable()
                                .frame(width: 24.0, height: 24.0)
                            Text(String(viewModel.eventThumbnails.count))
                        }
                    }
                    .frame(maxWidth: .infinity)
                    .tint(eventButtonTapped ? Color.black : Color(UIColor.lightGray))
                }
                .frame(maxWidth: .infinity, alignment: .topLeading)
                
                if self.comicButtonTapped {
                    ThumbnailsView(thumbnails: viewModel.comicThumbnails, attribution: viewModel.comicAttribution)
                } else if self.eventButtonTapped {
                    ThumbnailsView(thumbnails: viewModel.eventThumbnails, attribution: viewModel.eventAttribution)
                } else {
                    EmptyView()
                }
            }
        }
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                }
                label: {
                    Image(systemName: "ellipsis")
                }
            }
        }
        .task {
            if viewModel.comicThumbnails.isEmpty && viewModel.eventThumbnails.isEmpty {
                _ = try? await viewModel.loadCharacterDetails(character:character)
            }
        }
    }
}

#Preview {
    return CharacterDetailView(character:Character.mock())
        .task {
            MarvelService.shared.isMocked = true
        }
}
