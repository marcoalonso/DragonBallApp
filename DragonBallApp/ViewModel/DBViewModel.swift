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
    @Published var filteredCharacters: [DBZCharacter] = []
    @Published var detailsCharacter: CharacterDetailResponse?
    @Published var errorMessage: String = ""
    
    @Published private(set) var viewState: ViewState?
    
    
    var isLoading: Bool {
        viewState == .loading
    }
    
    var isFetching: Bool {
        viewState == .fetching
    }
    
    private let service = NetworkManager.shared
    private var cancellables = Set<AnyCancellable>()
    
    private var page = 1
    private var totalPages: Int?
    
    init () {
        getListOfCharacters()
    }
    
    
    func getDetails(numberCharacter: Int) {
        service.getDetailOfCharacters(numberCharcater: numberCharacter) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let detailsCharacter):
                    self?.detailsCharacter = detailsCharacter
                case .failure(let error):
                    self?.errorMessage = error.localizedDescription
                }
            }
        }
    }
    
    func getListOfCharacters(){
        viewState = .loading
        defer { viewState = .finished }
        
        service.getLisOfCharacters(numberPage: page) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let characters):
                    self?.characters = characters.items
                    self?.filteredCharacters = characters.items
                    self?.totalPages = characters.meta.totalPages
                case .failure(let error):
                    self?.errorMessage = error.localizedDescription
                }
            }
        }
    }
    
    func hasReachedEnd(of dbChar: DBZCharacter) -> Bool {
        characters.last?.id == dbChar.id
    }
    
    func filerCharacter(name: String) {
        if name.isEmpty {
            filteredCharacters = characters
        } else {
            filteredCharacters = characters.filter({ dbChar in
                dbChar.name.lowercased().contains(name.lowercased())
            })
        }
    }
    
    @MainActor
    func ferchNextSetOfCharacters() async {
        guard page != totalPages else { return }
        
        viewState = .fetching
        defer { viewState = .finished }
        
        page += 1
        
        service.getLisOfCharacters(numberPage: page) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let characters):
                     self?.filteredCharacters.append(contentsOf: characters.items)
                    self?.characters.append(contentsOf: characters.items)
                case .failure(let error):
                    self?.errorMessage = error.localizedDescription
                }
            }
        }
        
    }
    
    func getColorBasedOnRace(type: String) -> Color {
        switch type {
        case "Saiyan":
            return .orange
        case "Human":
            return .green
        case "Frieza Race":
            return .blue
        case "Android":
            return .yellow
        case "Nucleico":
            return .purple
        case "Nucleico benigno":
            return .pink
        case "Evil":
            return .red
        default:
            return Color(.systemGray5)
        }
    }
}

extension DBViewModel {
    enum ViewState {
        case fetching
        case loading
        case finished
    }
}
