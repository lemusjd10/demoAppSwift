//
//  BreedResponse.swift
//  Demo
//
//  Created by Julio Lemus on 13/02/21.
//

import Foundation

typealias BreedResponse = [Breed]

// MARK: - WelcomeElement
struct Breed: Codable {
    let weight: Weight
    let id, name: String
    let cfaURL: String?
    let vetstreetURL: String?
    let vcahospitalsURL: String?
    let temperament, origin, countryCodes, countryCode: String
    let valueDescription, lifeSpan: String
    let indoor: Int
    let lap: Int?
    let altNames: String?
    let adaptability, affectionLevel, childFriendly, dogFriendly: Int
    let energyLevel, grooming, healthIssues, intelligence: Int
    let sheddingLevel, socialNeeds, strangerFriendly, vocalisation: Int
    let experimental, hairless, natural, rare: Int
    let rex, suppressedTail, shortLegs: Int
    let wikipediaURL: String?
    let hypoallergenic: Int
    let referenceImageID: String?
    let image: Image?
    let catFriendly, bidability: Int?
    
    enum CodingKeys: String, CodingKey {
        case weight, id, name
        case cfaURL = "cfa_url"
        case vetstreetURL = "vetstreet_url"
        case vcahospitalsURL = "vcahospitals_url"
        case temperament, origin
        case countryCodes = "country_codes"
        case countryCode = "country_code"
        case valueDescription = "description"
        case lifeSpan = "life_span"
        case indoor, lap
        case altNames = "alt_names"
        case adaptability
        case affectionLevel = "affection_level"
        case childFriendly = "child_friendly"
        case dogFriendly = "dog_friendly"
        case energyLevel = "energy_level"
        case grooming
        case healthIssues = "health_issues"
        case intelligence
        case sheddingLevel = "shedding_level"
        case socialNeeds = "social_needs"
        case strangerFriendly = "stranger_friendly"
        case vocalisation, experimental, hairless, natural, rare, rex
        case suppressedTail = "suppressed_tail"
        case shortLegs = "short_legs"
        case wikipediaURL = "wikipedia_url"
        case hypoallergenic
        case referenceImageID = "reference_image_id"
        case image
        case catFriendly = "cat_friendly"
        case bidability
    }
}

// MARK: - Image
struct Image: Codable {
    let id: String?
    let width, height: Int?
    let url: String?
}

// MARK: - Weight
struct Weight: Codable {
    let imperial, metric: String
}


extension BreedResponse {
    func transformToViewModel() -> BreedsList {
        var temporalArray:BreedsList = []
        self.forEach { breed in
            let newBreed = BreedViewModel(id: breed.id , name: breed.name, urlImage: breed.image?.url ?? "", image: nil, description: breed.valueDescription, origin: breed.origin , temperament: breed.temperament, isFavorite: false)
            temporalArray.append(newBreed)
        }
        return temporalArray
    }
}
