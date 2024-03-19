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
    
    private let numberOfColumns = [
        GridItem(.flexible()),
        GridItem(.flexible()),
    ]
    
    var body: some View {
        NavigationStack {
            ScrollView {
                LazyVGrid(columns: numberOfColumns, spacing: 10) {
                    ForEach(viewModel.characters, id: \.id) { dbChar in
                        NavigationLink(destination: DBCharacterDetailView(dbChar: dbChar)) {
                            DBCharacterCellView(dbCharacter: dbChar, viewModel: viewModel)
                        }
                    }
                }
                .padding()
               
            }
            .onAppear {
                withAnimation {
                    viewModel.getListOfCharacters()
                }
            }
            .navigationBarTitle("Dragon Ball Z", displayMode: .inline)
        }
    }
}

#Preview {
    CharactersView()
}
