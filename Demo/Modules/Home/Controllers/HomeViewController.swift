//
//  HomeViewController.swift
//  Demo
//
//  Created by Julio Lemus on 13/02/21.
//

import UIKit
import UIScrollView_InfiniteScroll

class HomeViewController: UIViewController {
    
    fileprivate var currentPage = 1
    fileprivate var numPages = 0
    lazy var homeViewModel = HomeViewModel(delegate: self)
    @IBOutlet weak var collectionView: UICollectionView! {
        didSet {
            collectionView.delegate = self
            collectionView.dataSource = self
            collectionView.register(UINib(nibName: HomeCollectionViewCell.identifier, bundle: nil), forCellWithReuseIdentifier: HomeCollectionViewCell.identifier)
        }
    }
    var breedsList: BreedsList = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configurationInitial() 
        
    }
    
    func configurationInitial() {
        collectionView?.infiniteScrollIndicatorMargin = 40
        homeViewModel.getBreedsCats(page: "1")
        collectionView.addInfiniteScroll { [weak self] (collectionView) -> Void in
            guard let self = self else { return }
            collectionView.beginInfiniteScroll(true)
            self.homeViewModel.getBreedsCats(page: "\(self.currentPage)")
        }
    }
}

extension HomeViewController: UICollectionViewDelegateFlowLayout, UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return breedsList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HomeCollectionViewCell.identifier, for: indexPath) as? HomeCollectionViewCell
        let itemBreed = breedsList[indexPath.row]
        cell?.configure(breed: itemBreed, index: indexPath, delegate: self)
    
        return cell ?? UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let screenWidth = collectionView.frame.size.width / 3
        return CGSize(width: screenWidth, height: screenWidth)
    }
}
 
extension HomeViewController: HomeViewModelProtocol {
    func saveDataLocalSucces(_ message: String) {
        Toast.show(message: message, controller: self)
    }
    
    func didRetriveBreedsCats(_ breeds: BreedsList) {
        currentPage += 1
        let newItems = breeds
        let breedsCount = self.breedsList.count
        let (start, end) = (breedsCount, newItems.count + breedsCount)
        let indexPaths = (start..<end).map { return IndexPath(row: $0, section: 0) }
         
        self.breedsList.append(contentsOf: newItems)
         
        self.collectionView?.performBatchUpdates({ () -> Void in
            self.collectionView?.insertItems(at: indexPaths)
        }, completion: { (finished) -> Void in
            self.collectionView?.beginInfiniteScroll(false)
            self.collectionView?.finishInfiniteScroll()
        });
    }
    
    func didFailRetriveBreedsCats(_ message: String) {
        collectionView.beginInfiniteScroll(false)
        collectionView.finishInfiniteScroll()
    }
}

extension HomeViewController: HomeCollectionViewDelegate {
    func didTapOnGetDetail() {
    }
    
    func didTapOnSaveFavorite(_ index: IndexPath?, breed: BreedViewModel, isFavorite: Bool, imageData: Data?) {
        guard let indexValue = index else { return }
        let offsetBeforeReload = collectionView.contentOffset
        
        homeViewModel.saveDataLocal(breed, isFavorite: isFavorite, imageData: imageData?.base64EncodedString())
       
        collectionView.performBatchUpdates({
            self.breedsList[indexValue.row].isFavorite = isFavorite
            self.collectionView.reloadItems(at: [indexValue])
        }, completion: { _ in
            self.collectionView.setContentOffset(offsetBeforeReload, animated: false)
        })
    }
}
