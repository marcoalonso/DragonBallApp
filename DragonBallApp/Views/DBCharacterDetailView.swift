//
//  DBCharacterDetailView.swift
//  DragonBallApp
//
//  Created by Marco Alonso on 19/03/24.
//

import SwiftUI
import Kingfisher

struct DBCharacterDetailView: View {
    @State private var isAnimating = false
    
    let dbChar: DBZCharacter
    
    var body: some View {
        VStack {
            ImageCharacterView(url: dbChar.image, width: 190, heigh: 270)
                .shadow(radius: 12)
                .scaleEffect(isAnimating ? 1.2 : 0.7)
                .padding(.top, 40)
            
            Text(dbChar.name)
                .font(.system(size: 38))
            
            ScrollView(showsIndicators: false) {
                Text(dbChar.description)
                    .font(.title3)
                    .lineSpacing(10)
                    .fixedSize(horizontal: false, vertical: true)
            }
            .frame(height: 200)
            .padding()
            
            
            
            HStack(alignment: .top) {
                Text("Ki: \(dbChar.ki)")
                
                Text("Max Ki: \(dbChar.maxKi)")
                    .foregroundColor(.gray)
                
            }
            .font(.caption)
            
            
            HStack {
                Text(dbChar.race)
                    .foregroundColor(.red)
                
                Text("-")
                
                Text(dbChar.affiliation)
                    .font(.subheadline)
            }
            
        }
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                withAnimation {
                    isAnimating = true
                }
            }
        }
    }
}

#Preview {
    DBCharacterDetailView(dbChar: MockData.dbCharacters[1])
}
