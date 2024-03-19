//
//  CharactersView.swift
//  DragonBallApp
//
//  Created by Marco Alonso on 19/03/24.
//

import SwiftUI

struct CharactersView: View {
    @StateObject var viewModel = DBViewModel()
    
    var body: some View {
        NavigationStack {
            ScrollView {
                ForEach(viewModel.characters, id: \.id) { dbChar in
                    VStack {
                        Text(dbChar.name)
                            .font(.title)
                            .foregroundColor(.red)
                        
                        Text("Ki: \(dbChar.ki)")
                            .font(.title3)
                            .foregroundColor(.gray)
                    }
                }
            }
            .onAppear {
                    viewModel.getListOfCharacters()
            }
        }
    }
}

#Preview {
    CharactersView()
}
