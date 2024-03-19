//
//  DBCharacterCellView.swift
//  DragonBallApp
//
//  Created by Marco Alonso on 19/03/24.
//

import SwiftUI
import Kingfisher

struct DBCharacterCellView: View {
    let dbCharacter: DBZCharacter
    @StateObject var viewModel: DBViewModel
    
    var body: some View {
        ZStack {
            Rectangle()
                .foregroundColor(viewModel.getColorBasedOnRace(type: dbCharacter.race))
                .cornerRadius(25)
            
            VStack {
                ImageCharacterView(url: dbCharacter.image, width: 90, heigh: 170)
                
                Text(dbCharacter.name)
                    .font(.title2)
                    .foregroundColor(.white)
            }
        }
    }
}

#Preview {
    DBCharacterCellView(dbCharacter: MockData.dbCharacters[0], viewModel: DBViewModel())
}
