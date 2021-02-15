//
//  HomeCollectionView.swift
//  Demo
//
//  Created by Julio Lemus on 13/02/21.
//

import UIKit
import Kingfisher

protocol HomeCollectionViewDelegate: class {
    func didTapOnGetDetail() 
    func didTapOnSaveFavorite(_ index: IndexPath?, breed: BreedViewModel, isFavorite: Bool, imageData: Data?)
}

class HomeCollectionView: UIView {
    
    weak var delegate: HomeCollectionViewDelegate?
    @IBOutlet weak var breedImage: UIImageView!
    @IBOutlet weak var titleBreedLabel: UILabel!
    @IBOutlet weak var favoriteButton: UIButton!
    var breedSelected: BreedViewModel!
    var index: IndexPath?
    
    var view: UIView!
    
    override func layoutSubviews() {
        super.layoutSubviews()
        configureUI()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        loadViewFromNib()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        loadViewFromNib()
    }
    
    func configureUI() {
        self.layer.masksToBounds = true
        self.layer.cornerRadius = 12
        self.layer.borderWidth = 1
        self.layer.borderColor = UIColor.lightGray.withAlphaComponent(0.5).cgColor
        self.dropShadow()
    }
    
    func configure(breed: BreedViewModel,
                   index: IndexPath?,delegate: HomeCollectionViewDelegate?) {
        breedImage.downloadImage(url: breed.urlImage)
        titleBreedLabel.text = breed.name
        breedSelected = breed
        self.delegate = delegate
        self.index = index
        let image = breed.isFavorite ? UIImage(systemName: "heart.fill") :  UIImage(systemName: "heart")
        favoriteButton.setBackgroundImage( image, for: .normal)
    }
    
    func configureFavorite(breed: BreedViewModel,
                           index: IndexPath?,delegate: HomeCollectionViewDelegate?) {
        breedImage.image = UIImage(data: breed.image ?? Data())
        titleBreedLabel.text = breed.name
        breedSelected = breed
        self.delegate = delegate
        self.index = index
        let image = breed.isFavorite ? UIImage(systemName: "heart.fill") :  UIImage(systemName: "heart")
        favoriteButton.setBackgroundImage( image, for: .normal)
    }
    
    @IBAction func didTapOnFavorite(_ sender: UIButton) {
        let isFavorite:Bool = !breedSelected.isFavorite
        let imageData = breedImage.image?.pngData()
        delegate?.didTapOnSaveFavorite(index, breed: breedSelected, isFavorite: isFavorite, imageData: imageData)
    }
    
    private func loadViewFromNib() {
        view = loadNib()
        view.frame = bounds
        view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.addSubview(view)
    } 
}
