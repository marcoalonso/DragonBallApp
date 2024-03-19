//
//  NetworkManager.swift
//  DragonBallApp
//
//  Created by Marco Alonso on 19/03/24.
//

import UIKit

class NetworkManager: NSObject, ObservableObject {
    @Published var listCharacters: [DBZCharacter] = []
    @Published var totalPages: Int = 0
    @Published var errorMessage: String = ""
    @Published var characterDetail: CharacterDetailResponse? = nil
    
    static let shared = NetworkManager()
    private let cache = NSCache<NSString, UIImage>()
    
    
    static let baseURL = "https://dragonball-api.com/api/characters?page="
    static let detailCharacterURL = "https://dragonball-api.com/api/characters/"

    
    private override init() {}
    
    func getLisOfCharacters(numberPage: Int) {
        guard let url = URL(string: NetworkManager.baseURL+"\(numberPage)"+"&limit=10" ) else { return }
        print("Debug: url \(url)")
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let _ = error { return }
            
            guard let response = response as? HTTPURLResponse, response.statusCode == 200 else { return }
            print("Debug: response \(response.statusCode)")
            
             guard let data = data else { return }
            
            
            do {
                let decoder = JSONDecoder()
                let decodedResponse = try decoder.decode(CharacterResponse.self, from: data)
                self.listCharacters = decodedResponse.items
                self.totalPages = decodedResponse.meta.totalPages
                print("Debug: items \(decodedResponse.items.count)")
            } catch {
                print("Debug: decoding error \(error.localizedDescription)")
                self.errorMessage = error.localizedDescription
            }
        }
        task.resume()
    }
    
    func getDetailOfCharacters(numberCharcater: Int) {
        guard let url = URL(string: NetworkManager.detailCharacterURL+"\(numberCharcater)" ) else { return }
        print("Debug: url \(url)")
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let _ = error { return }
            
            guard let response = response as? HTTPURLResponse, response.statusCode == 200 else { return }
            print("Debug: response \(response.statusCode)")
            
             guard let data = data else { return }
            
            
            do {
                let decoder = JSONDecoder()
                let decodedResponse = try decoder.decode(CharacterDetailResponse.self, from: data)
                self.characterDetail = decodedResponse
                print("Debug: decodedResponse  \(decodedResponse)")
            } catch {
                print("Debug: decoding error \(error.localizedDescription)")
                self.errorMessage = error.localizedDescription
            }
        }
        task.resume()
    }
}
