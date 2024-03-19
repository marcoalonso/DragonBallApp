//
//  DBViewModel.swift
//  DragonBallApp
//
//  Created by Marco Alonso on 19/03/24.
//

import SwiftUI
import Combine
 
class DBViewModel: ObservableObject {
    @Published var characters: [DBZCharacter] = []
    
    private let service = NetworkManager.shared
    private var cancellables = Set<AnyCancellable>()
    
    init () {
        setupSubscribers()
    }
    
    func setupSubscribers() {
        service.$listCharacters.sink { [weak self] characters in
            DispatchQueue.main.async {
                self?.characters = characters
            }
        }
        .store(in: &cancellables)
    }
    
    func getListOfCharacters(){
        service.getLisOfCharacters()
    }
    
    func getColorBasedOnType(type: Affiliation) -> Color {
        switch type {
        case .armyOfFrieza:
            return .orange
        case .freelancer:
            return .green
        case .zFighter:
            return .red
        }
    }
}
