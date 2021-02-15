//
//  FavoritesViewModel.swift
//  Demo
//
//  Created by Julio Lemus on 14/02/21.
//

import Foundation

protocol  FavoritesViewModelProtocol{
    func didFailRetriveFavorites(_ message: String)
}

class FavoritesViewModel {
    
    private let delegate: FavoritesViewModelProtocol?
    init(_ view: FavoritesViewModelProtocol) {
        self.delegate = view
    }
    
    func getAllFavorites() -> [BreedViewModel]{ 
        return CoreDataManagerBreeds.sharedInstance.getBreedsViewModels()
    }
}
