//
//  ImageTransformationView.swift
//  DragonBallApp
//
//  Created by Marco Alonso on 19/03/24.
//

import SwiftUI

struct ImageTransformationView: View {
    
    let urlImage: String
    
    var body: some View {
        ZStack {
            
            Rectangle()
                .fill(
                    LinearGradient(colors: [.blue, .white], startPoint: .top, endPoint: .bottom)
                )
                .edgesIgnoringSafeArea(.all)
            
            ImageCharacterView(url: urlImage, width: SizeConstants.cardWidth, heigh: SizeConstants.cardHeigth)
        }
    }
}

#Preview {
    ImageTransformationView(urlImage: MockData.dbCharacters[1].image)
}


struct SizeConstants {
    static var cardWidth: CGFloat {
       UIScreen.main.bounds.width - 20
   }
   
    static var cardHeigth: CGFloat {
       UIScreen.main.bounds.height / 1.45
   }
}

