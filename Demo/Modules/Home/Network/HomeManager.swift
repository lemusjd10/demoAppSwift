//
//  HomeManager.swift
//  Demo
//
//  Created by Julio Lemus on 13/02/21.
//

import Foundation


protocol HomeManagerProtocol {
    func didRetriveBreedsCats(_ breeds: BreedsList)
    func didFailRetriveBreedCats(_ message: String)
}
class HomeManager {
    
    private var delegate: HomeManagerProtocol?
    private var dataListBreeds: BreedsList = []
    
    init(_ view: HomeManagerProtocol? = nil) {
        self.delegate = view
    }
    
    func retriveBreedsCats(page: String, limit: String){
        let endpoint = Endpoint.breedsPaginate(page: page, limit: limit)
        APIClient().request(api: endpoint.path, someClass: BreedResponse.self,param: [:]) { (response, error) in
            guard let breedList =  response else {
                self.delegate?.didFailRetriveBreedCats(.messageFail)
                return
            }
            
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                if breedList.count > 0 {
                    self.delegate?.didRetriveBreedsCats(breedList.transformToViewModel())
                }else{
                    self.delegate?.didFailRetriveBreedCats(.notAvailables)
                }
            }
        }
    }
}
