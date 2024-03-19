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
    @StateObject var viewModel: DBViewModel
    
    let dbChar: DBZCharacter
    
    
    var body: some View {
        ScrollView {
            VStack {
                ImageCharacterView(url: dbChar.image, width: 140, heigh: 230)
                    .shadow(radius: 12)
                    .scaleEffect(isAnimating ? 1.2 : 0.7)
                    .padding(.top, 40)
                
                Text(dbChar.name)
                    .font(.largeTitle)
                    .foregroundColor(.blue)
                
                
                Text(dbChar.description)
                    .font(.footnote)
                    .padding()
                
                if let transformation = viewModel.detailsCharacter?.transformations {
                    Text("Transformaciones")
                        .font(.subheadline)
                        .fontWeight(.semibold)
                        .foregroundColor(.red)
                    
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 12.0) {
                            ForEach(transformation) { transformation in
                                VStack {
                                    ImageCharacterView(url: transformation.image, width: 70, heigh: 120)
                                        
                                    Text(transformation.name)
                                        .lineLimit(1)
                                        .font(.footnote)
                                }
                                .frame(width: 100)
                                .overlay {
                                    RoundedRectangle(cornerRadius: 10)
                                        .stroke(Color(.systemGray4), lineWidth: 2)
                                }
                            }
                        }
                    }
                    .padding(.horizontal, 16)
                }
                
                
                
                HStack(alignment: .top) {
                    Text("Ki: \(dbChar.ki)")
                    
                    Text("Max Ki: \(dbChar.maxKi)")
                        .foregroundColor(.gray)
                    
                }
                .font(.caption)
                .padding(.top, 24)
                
                
                HStack {
                    Text(dbChar.race)
                        .foregroundColor(.red)
                    
                    Text("-")
                    
                    Text(dbChar.affiliation)
                        .font(.subheadline)
                }
                .padding(.top, 10)
                
            }
            .onAppear {
                viewModel.getDetails(numberCharacter: dbChar.id)
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                    withAnimation {
                        isAnimating = true
                    }
                }
        }
        }
    }
}

#Preview {
    DBCharacterDetailView(viewModel: DBViewModel(), dbChar: MockData.dbCharacters[1])
}
