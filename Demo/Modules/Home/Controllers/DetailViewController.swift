//
//  DetailViewController.swift
//  Demo
//
//  Created by Julio Lemus on 13/02/21.
//

import UIKit

class DetailViewController: UIViewController {

    @IBOutlet weak var headerHomeView: HomeCollectionView!
    
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var temperamentLabel: UILabel!
    var itemViewModel: BreedViewModel!
     
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }
    
    func configureUI() {
        descriptionLabel.text = itemViewModel?.description
        temperamentLabel.text = " Temperamento: \(itemViewModel?.temperament ?? "No disponible")"
        headerHomeView.configure(breed: itemViewModel, index: IndexPath(), delegate: self)
    }
    
}

extension DetailViewController: HomeCollectionViewDelegate {
    func didTapOnGetDetail() {
         
    }
    
    func didTapOnSaveFavorite(_ index: IndexPath?, breed: BreedViewModel, isFavorite: Bool, imageData: Data?) {
         
    } 
}
