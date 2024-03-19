//
//  NetworkManager.swift
//  DragonBallApp
//
//  Created by Marco Alonso on 19/03/24.
//

import UIKit

class NetworkManager: NSObject, ObservableObject {
    ///To use combine we need implement this var and adopt ObservableObject
    @Published var listCharacters: [DBZCharacter] = []
    @Published var errorMessage: String = ""
    
    static let shared = NetworkManager()
    private let cache = NSCache<NSString, UIImage>()
    
    
    static let baseURL = "https://dragonball-api.com/api/characters"
    
    private override init() {}
    
    ///Using combine instead of closure
    func getLisOfCharacters() {
        guard let url = URL(string: NetworkManager.baseURL ) else { return }
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let _ = error { return }
            
            guard let response = response as? HTTPURLResponse, response.statusCode == 200 else { return }
            
            guard let data = data else { return }
            
            do {
                let decoder = JSONDecoder()
                let decodedResponse = try decoder.decode(CharacterResponse.self, from: data)
                self.listCharacters = decodedResponse.items
                print("Debug: listCharacters \(self.listCharacters)")
            } catch {
                print("Debug: decoding error \(error.localizedDescription)")
                self.errorMessage = error.localizedDescription
            }
        }
        task.resume()
    }
    
    
    func downloadImage(from urlString: String, completed: @escaping (UIImage?) -> Void) {
        
        let cacheKey = NSString(string: urlString)
        
        if let image = cache.object(forKey: cacheKey) {
            completed(image)
            return
        }
        
        guard let url = URL(string: urlString) else {
            completed(nil)
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data, let image = UIImage(data: data) else {
                completed(nil)
                return
            }
            
            self.cache.setObject(image, forKey: cacheKey)
            completed(image)
        }
        
        task.resume()
    }
}
