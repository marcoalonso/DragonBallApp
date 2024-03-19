//
//  CharacterDetailResponse.swift
//  DragonBallApp
//
//  Created by Marco Alonso on 19/03/24.
//

import Foundation

struct CharacterDetailResponse: Codable {
    let id: Int
    let name, ki, maxKi, race: String
    let gender, description: String
    let image: String
    let affiliation: String
    let originPlanet: OriginPlanet
    let transformations: [Transformation]
}

// MARK: - OriginPlanet
struct OriginPlanet: Codable {
    let id: Int
    let name: String
    let isDestroyed: Bool
    let description: String
    let image: String
}

// MARK: - Transformation
struct Transformation: Codable, Identifiable {
    let id: Int
    let name: String
    let image: String
    let ki: String
}
