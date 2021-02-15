//
//  HomeCollectionViewCell.swift
//  Demo
//
//  Created by Julio Lemus on 13/02/21.
//

import UIKit

class HomeCollectionViewCell: UICollectionViewCell {

    static let identifier = "HomeCollectionViewCell"
    @IBOutlet weak var homeCollectionView: HomeCollectionView!
      
    func configure(breed: BreedViewModel, index: IndexPath?, delegate: HomeCollectionViewDelegate?){
        homeCollectionView.configure(breed: breed, index: index, delegate: delegate)
    }
    
    func configureFavorite(breed: BreedViewModel, index: IndexPath?, delegate: HomeCollectionViewDelegate?){
        homeCollectionView.configureFavorite(breed: breed, index: index, delegate: delegate)
    }
}
