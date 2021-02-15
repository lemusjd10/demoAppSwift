//
//  HomeViewModel.swift
//  Demo
//
//  Created by Julio Lemus on 13/02/21.
//

protocol HomeViewModelProtocol {
    func didRetriveBreedsCats(_ breeds: BreedsList)
    func didFailRetriveBreedsCats(_ message: String)
    func saveDataLocalSucces(_ message: String)
}

class HomeViewModel {
    
    private var delegate: HomeViewModelProtocol?
    private lazy var apiManager: HomeManager = {
        let api = HomeManager(self)
        return api
    }()
    
    init(delegate: HomeViewModelProtocol) {
        self.delegate = delegate 
    }
    
    func getBreedsCats(page: String, limit: String = "6") {
        apiManager.retriveBreedsCats(page: page, limit: limit)
    }
    
    func saveDataLocal(_ breed: BreedViewModel, isFavorite: Bool, imageData: String?){
        debugPrint("Total Items Local Saves: \(CoreDataManagerBreeds.sharedInstance.getAllBreeds().count)")
        
        if isFavorite {
            let breedFind = CoreDataManagerBreeds.sharedInstance.getSingleBreed(breedId: breed.id)
                if breedFind?.id ?? "" != breed.id {
                    CoreDataManagerBreeds.sharedInstance.saveBreed(breed, imageData: imageData)
                    delegate?.saveDataLocalSucces("Guardado Exitósamente.")
                    debugPrint("Save Item Core Data")                    
                }
        }else{
            let breedFind = CoreDataManagerBreeds.sharedInstance.getSingleBreed(breedId: breed.id)
            if let breedNew = breedFind {
                CoreDataManagerBreeds.sharedInstance.deleteBreed(breedNew)
                delegate?.saveDataLocalSucces("Eliminado Exitósamente.")
                debugPrint("Remove Item Core Data")
            }
        }
    }
}

extension HomeViewModel: HomeManagerProtocol {
    func didRetriveBreedsCats(_ breeds: BreedsList) {
        delegate?.didRetriveBreedsCats(breeds)
    }
    
    func didFailRetriveBreedCats(_ message: String) {
        delegate?.didFailRetriveBreedsCats(message)
    }
}
