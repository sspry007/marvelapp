//
//  CharacterView.swift
//  marvelapp
//
//  Created by Steven Spry on 3/10/25.
//

import SwiftUI

struct CharacterView: View {
    @ObservedObject var viewModel = CharacterViewModel()
    @State private var isRunning = false
    let columns = [GridItem(),GridItem(),GridItem()]

    var body: some View {
        NavigationStack {
            if !viewModel.isConnected {
                ProgressView("Loading your Characters.  Please wait.")
                    .padding([.top],150)
            }
            ScrollView {
                LazyVGrid(columns:columns, spacing: 0) {
                    ForEach(viewModel.characters, id: \.self) { character in
                        NavigationLink {
                            CharacterDetailView(character: character)
                                .toolbarRole(.editor)
                        }
                        label: {
                            ZStack {
                                ImageView(character.thumbnail) { image in
                                    image
                                        .resizable()
                                        .scaledToFit()
                                } placeholder: {
                                    ProgressView()
                                }
                                .frame(width: viewModel.itemWidth, height: viewModel.itemWidth, alignment: .center)
                                .overlay(
                                    Text(character.name)
                                        .padding([.leading,.trailing],5)
                                        .font(.caption2)
                                        .foregroundStyle(.white),
                                    alignment: .bottomLeading)
                            }
                        }
                    }
                }
            }
            if viewModel.isConnected {
                VStack {
                    Button {
                        Task {
                            isRunning = true
                            _ = try? await viewModel.loadNextCharacters()
                            isRunning = false
                        }
                    }
                    label: {
                        HStack {
                            Text("Load More")
                                .bold()
                        }
                    }
                    .padding([.top],0)
                    .buttonStyle(.borderedProminent)
                    .disabled(isRunning)
                    
                    Text(viewModel.attribution)
                        .font(.caption2)
                }
            }
            
        }
        .task {
            if viewModel.characters.isEmpty {
                isRunning = true
                let _ = try? await viewModel.loadCharacters()
                isRunning = false
            }
        }
        .accentColor(Color(UIColor.darkGray))
    }
}

#Preview {
    CharacterView()
}
