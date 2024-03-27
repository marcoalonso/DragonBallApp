//
//  NetworkManager.swift
//  DragonBallApp
//
//  Created by Marco Alonso on 19/03/24.
//

import UIKit

enum APError: Error {
    case invalidURL
    case unableToComplete
    case invalidResponse
    case invalidData
    case decodingError
}

class NetworkManager: NSObject, ObservableObject {
    static let shared = NetworkManager()
    
    static let baseURL = "https://dragonball-api.com/api/characters?page="
    static let detailCharacterURL = "https://dragonball-api.com/api/characters/"

    
    func getLisOfCharacters(numberPage: Int, completed: @escaping (Result<CharacterResponse, APError>) -> Void) {
        guard let url = URL(string: NetworkManager.baseURL+"\(numberPage)"+"&limit=10" ) else {
            completed(.failure(.invalidURL))
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let _ = error {
                completed(.failure(.unableToComplete))
                return
            }
            
            guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                completed(.failure(.invalidResponse))
                return
            }
            
            guard let data = data else {
                completed(.failure(.invalidData))
                return
            }
            
            
            do {
                let decoder = JSONDecoder()
                let decodedResponse = try decoder.decode(CharacterResponse.self, from: data)
                completed(.success(decodedResponse))
            } catch {
                print("Debug: decoding error \(error.localizedDescription)")
                completed(.failure(.decodingError))
            }
        }
        task.resume()
    }
    
    func getDetailOfCharacters(numberCharcater: Int, completed: @escaping (Result<CharacterDetailResponse, APError>) -> Void ) {
        guard let url = URL(string: NetworkManager.detailCharacterURL+"\(numberCharcater)" ) else {
            completed(.failure(.invalidURL))
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let _ = error {
                completed(.failure(.unableToComplete))
                return
            }
            
            guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                completed(.failure(.invalidResponse))
                return
            }
            
            
            guard let data = data else {
                completed(.failure(.invalidData))
                return
            }
            
            
            do {
                let decoder = JSONDecoder()
                let decodedResponse = try decoder.decode(CharacterDetailResponse.self, from: data)
                completed(.success(decodedResponse))
            } catch {
                print("Debug: decoding error \(error.localizedDescription)")
                completed(.failure(.decodingError))
            }
        }
        task.resume()
    }
}
