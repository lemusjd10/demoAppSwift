//
//  FavoritesViewController.swift
//  Demo
//
//  Created by Julio Lemus on 14/02/21.
//

import UIKit

class FavoritesViewController: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView! {
        didSet {
            collectionView.delegate = self
            collectionView.dataSource = self
            collectionView.register(UINib(nibName: HomeCollectionViewCell.identifier, bundle: nil), forCellWithReuseIdentifier: HomeCollectionViewCell.identifier)
        }
    }
    
    lazy var viewModel: FavoritesViewModel = {
        let viewM = FavoritesViewModel(self)
        return viewM
    }()
    
    var breedsList: BreedsList = [] {
        didSet{
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad() 
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        breedsList = viewModel.getAllFavorites()
    }
}

extension FavoritesViewController: UICollectionViewDelegateFlowLayout, UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return breedsList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HomeCollectionViewCell.identifier, for: indexPath) as? HomeCollectionViewCell
        let itemBreed = breedsList[indexPath.row]
        cell?.configureFavorite(breed: itemBreed, index: indexPath, delegate: self)
    
        return cell ?? UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let screenWidth = collectionView.frame.size.width / 3
        return CGSize(width: screenWidth, height: screenWidth)
    }
}
 
extension FavoritesViewController: HomeCollectionViewDelegate {  
    func didTapOnGetDetail() {
    }
    
    func didTapOnSaveFavorite(_ index: IndexPath?, breed: BreedViewModel, isFavorite: Bool, imageData: Data?) {
        guard let _ = index else { return }
        let breedFind = CoreDataManagerBreeds.sharedInstance.getSingleBreed(breedId: breed.id)
        if let breedNew = breedFind {
            CoreDataManagerBreeds.sharedInstance.deleteBreed(breedNew)
            debugPrint("Remove Item Core Data in Favorites")
        }
         
        breedsList = []
        breedsList = viewModel.getAllFavorites()
    }
}

extension FavoritesViewController: FavoritesViewModelProtocol {
    func didFailRetriveFavorites(_ message: String) {
        
    }
}
