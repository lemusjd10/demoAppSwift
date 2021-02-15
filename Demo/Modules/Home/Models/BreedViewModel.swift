//
//  BreedViewModel.swift
//  Demo
//
//  Created by Julio Lemus on 13/02/21.
//

import Foundation 

typealias BreedsList = [BreedViewModel]

struct BreedViewModel {
    let id: String
    let name: String
    let urlImage: String
    let image: Data?
    let description: String?
    let origin: String?
    let temperament: String?
    var isFavorite: Bool
}
