//
//  ImageCharacterView.swift
//  DragonBallApp
//
//  Created by Marco Alonso on 19/03/24.
//

import SwiftUI
import Kingfisher

struct ImageCharacterView: View {
    
    let url: String
    let width: CGFloat
    let heigh: CGFloat
    
    var body: some View {
        KFImage(URL(string: url))
            .resizable()
            .frame(width: width, height: heigh)
    }
}

#Preview {
    ImageCharacterView(url: MockData.dbCharacters[1].image, width: 100, heigh: 150)
}
