//
//  Models.swift
//  CatsDogs
//
//  Created by B-Arsekin on 30.12.2024.
//

import Foundation

struct AnimalModel: Codable, Identifiable, Sendable, Hashable {
    let id: String
    let url: String
}

struct AnimalInfoModel: Codable, Hashable {
    let id: String
    let url: String
    let breeds: [BreedModel]
}

struct BreedModel: Codable, Hashable, Identifiable {
    let weight: WeightModel
    let id: String
    let name: String
    let temperament: String
    let origin: String
    let description: String
    let lifeSpan: String
    let altNames: String
    
    enum CodingKeys: String, CodingKey {
        case weight
        case id
        case name
        case temperament
        case origin
        case description
        case lifeSpan = "life_span"
        case altNames = "alt_names"
    }
}

struct WeightModel: Codable, Hashable {
    let imperial: String
    let metric: String
}
