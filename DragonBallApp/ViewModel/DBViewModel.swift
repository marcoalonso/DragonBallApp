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
        setupSubscribers()
    }
    
    func setupSubscribers() {
        //  Characters
        service.$listCharacters.sink { [weak self] characters in
            DispatchQueue.main.async {
                self?.characters.append(contentsOf: characters)
                self?.filteredCharacters.append(contentsOf: characters)
            }
        }
        .store(in: &cancellables)
        
        //  TotalPages
        service.$totalPages.sink { [weak self] pages in
            DispatchQueue.main.async {
                self?.totalPages = pages
            }
        }
        .store(in: &cancellables)
        
        
        service.$characterDetail.sink { [weak self] details in
            if let detailsC = details {
                print("Debug: detailsC: \(detailsC)")
                self?.detailsCharacter = detailsC
            }
        }
        .store(in: &cancellables)
    }
    
    func getDetails(numberCharacter: Int) {
        service.getDetailOfCharacters(numberCharcater: numberCharacter)
    }
    
    func getListOfCharacters(){
        viewState = .loading
        defer { viewState = .finished }
        service.getLisOfCharacters(numberPage: page)
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
        
        service.getLisOfCharacters(numberPage: page)
        print("Debug: page \(page)")
    }
    
    func getColorBasedOnType(type: String) -> Color {
        switch type {
        case "Army of Frieza":
            return .blue
        case "Freelancer":
            return .green
        case "Z Fighter":
            return .orange
        default:
            return Color(.systemGray3)
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
