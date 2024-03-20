//
//  CharactersView.swift
//  DragonBallApp
//
//  Created by Marco Alonso on 19/03/24.
//

import SwiftUI
import Kingfisher

struct CharactersView: View {
    @StateObject var viewModel = DBViewModel()
    @State private var characterToSearch = ""
    
    private let numberOfColumns = [
        GridItem(.flexible()),
        GridItem(.flexible()),
    ]
    
    var body: some View {
        NavigationStack {
            ScrollView {
                LazyVGrid(columns: numberOfColumns, spacing: 10) {
                    ForEach(viewModel.filteredCharacters, id: \.id) { dbChar in
                        NavigationLink(destination: DBCharacterDetailView(viewModel: viewModel, dbChar: dbChar)) {
                            DBCharacterCellView(dbCharacter: dbChar, viewModel: viewModel)
                                .task {
                                    if viewModel.hasReachedEnd(of: dbChar) && !viewModel.isFetching {
                                        await viewModel.ferchNextSetOfCharacters()
                                        print("Debug: ferchNextSetOfCharacters")
                                    }
                                }
                        }
                    }
                }
                .padding()
                if viewModel.isLoading {
                    ProgressView()
                }
            }
            .searchable(text: $characterToSearch, prompt: "Buscar")
            .onChange(of: characterToSearch, { oldValue, newValue in
                print("Debug: newValue \(newValue)")
                withAnimation {
                    viewModel.filerCharacter(name: newValue)
                }
            })
            .navigationBarTitle("Dragon Ball Z", displayMode: .inline)
        }
    }
}

#Preview {
    CharactersView()
}
