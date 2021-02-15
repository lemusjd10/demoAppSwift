//
//  CoreDataManager.swift
//  Demo
//
//  Created by Julio Lemus on 13/02/21.
//


import UIKit
import CoreData

enum BreedAttributes: String {
    case id                = "id"
    case name              = "name"
    case origin            = "origin"
    case descriptionValue  = "descriptionValue"
    case temperament       = "temperament"
    case image             = "image"
    
    static let getAll = [
        id,
        name,
        origin,
        descriptionValue,
        temperament,
        image
    ]
}

class CoreDataManagerBreeds {
    
    fileprivate let persistenceManager: PersistenceManager!
    fileprivate var mainContextInstance: NSManagedObjectContext!
    
    fileprivate let idBreed = "id"
    fileprivate let name = "name"
    fileprivate let origin = "origin"
    fileprivate let descriptionValue = "descriptionValue"
    fileprivate let temperament = "temperament"
    fileprivate let image = "image"
    fileprivate let breedEntity = "BreedCore"
    
    class var sharedInstance: CoreDataManagerBreeds {
        struct Singleton {
            static let instance = CoreDataManagerBreeds()
        }
        
        return Singleton.instance
    }
    
    init() {
        self.persistenceManager = PersistenceManager.sharedInstance
        self.mainContextInstance = persistenceManager.getMainContextInstance()
    }
    
    func getBreedsViewModels() -> [BreedViewModel] {
        var itemsViewModel:[BreedViewModel] = []
        let breedsCoreLocal = CoreDataManagerBreeds.sharedInstance.getAllBreeds()
        breedsCoreLocal.forEach { breed in
            let newViewModel = BreedViewModel(id: breed.id ?? "", name: breed.name ?? "", urlImage: "", image: breed.image, description: breed.descriptionValue ?? "", origin: breed.origin ?? "", temperament: breed.temperament ?? "", isFavorite: true)
            itemsViewModel.append(newViewModel)
        }
        return itemsViewModel
    }
    
    func getSingleBreed(breedId: String) -> BreedCore? {
        var fetchedResultBreed: BreedCore?
        
        // Create request on Breed entity
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: breedEntity)
        
        //Execute Fetch request
        do {
            let fetchedResults = try  self.mainContextInstance.fetch(fetchRequest) as! [BreedCore]
            fetchRequest.fetchLimit = 1
            
            if fetchedResults.count != 0 {
                fetchedResultBreed =  fetchedResults.first
            }
        } catch let fetchError as NSError {
            print("retrieve single Breed error: \(fetchError.localizedDescription)")
        }
        
        return fetchedResultBreed
    }
    
    func saveBreed(_ breedDetails: Dictionary<String, AnyObject>) {
        
        //Minion Context worker with Private Concurrency type.
        let minionManagedObjectContextWorker: NSManagedObjectContext =
            NSManagedObjectContext.init(concurrencyType: NSManagedObjectContextConcurrencyType.privateQueueConcurrencyType)
        minionManagedObjectContextWorker.parent = self.mainContextInstance
        
        //Create new Object of Breed entity
        let breedItem = NSEntityDescription.insertNewObject(forEntityName: breedEntity,
                                                            into: minionManagedObjectContextWorker) as! BreedCore
        
        //Assign field values
        for (key, value) in breedDetails {
            for attribute in BreedAttributes.getAll {
                if (key == attribute.rawValue) {
                    breedItem.setValue(value, forKey: key)
                }
            }
        }
        
        //Save current work on Minion workers
        self.persistenceManager.saveWorkerContext(minionManagedObjectContextWorker)
        
        //Save and merge changes from Minion workers with Main context
        self.persistenceManager.mergeWithMainContext()
        
        //Post notification to update datasource of a given Viewcontroller/UITableView
        self.postUpdateNotification()
    }
    
    func saveBreed(_ breed: BreedViewModel, imageData: String? = nil) {
        
        //Minion Context worker with Private Concurrency type.
        let minionManagedObjectContextWorker: NSManagedObjectContext =
            NSManagedObjectContext.init(concurrencyType: NSManagedObjectContextConcurrencyType.privateQueueConcurrencyType)
        minionManagedObjectContextWorker.parent = self.mainContextInstance
        
        //Create new Object of Breed Breed
        let breedItem = NSEntityDescription.insertNewObject(forEntityName: breedEntity,
                                                            into: minionManagedObjectContextWorker) as! BreedCore
        
        breedItem.id = breed.id
        breedItem.name = breed.name
        breedItem.origin = breed.origin
        breedItem.temperament = breed.temperament
        breedItem.image = Data(base64Encoded: imageData ?? "")
        
        //Save current work on Minion workers
        self.persistenceManager.saveWorkerContext(minionManagedObjectContextWorker)
        
        //Save and merge changes from Minion workers with Main context
        self.persistenceManager.mergeWithMainContext()
        
        //Post notification to update datasource of a given Viewcontroller/UITableView
        self.postUpdateNotification()
    }
    
    func saveBreedsList(_ breedList: Array<AnyObject>) {
        DispatchQueue.global().async {
            
            //Minion Context worker with Private Concurrency type.
            let minionManagedObjectContextWorker: NSManagedObjectContext =
                NSManagedObjectContext.init(concurrencyType: NSManagedObjectContextConcurrencyType.privateQueueConcurrencyType)
            minionManagedObjectContextWorker.parent = self.mainContextInstance
            
            //Create breeEntity, process member field values
            for index in 0..<breedList.count {
                let breedItem: Dictionary<String, NSObject> = breedList[index] as! Dictionary<String, NSObject>
                
                //Check that an Breed to be stored has a date, title and city.
                if breedItem[self.idBreed] as! String != ""
                    && breedItem[self.name] as! String != "" {
                    
                    //Create new Object of Breed entity
                    let item = NSEntityDescription.insertNewObject(forEntityName: self.breedEntity,
                                                                   into: minionManagedObjectContextWorker) as! BreedCore
                    
                    //Add member field values
                    item.setValue((breedItem[self.idBreed] as! String), forKey: self.idBreed)
                    item.setValue(breedItem[self.name], forKey: self.name)
                    item.setValue(breedItem[self.origin], forKey: self.origin)
                    item.setValue(breedItem[self.descriptionValue], forKey: self.descriptionValue)
                    item.setValue(breedItem[self.temperament], forKey: self.temperament)
                    item.setValue(breedItem[self.image], forKey: self.image)
                    
                    
                    //Save current work on Minion workers
                    self.persistenceManager.saveWorkerContext(minionManagedObjectContextWorker)
                }
            }
            
            //Save and merge changes from Minion workers with Main context
            self.persistenceManager.mergeWithMainContext()
            
            //Post notification to update datasource of a given Viewcontroller
            DispatchQueue.main.async {
                self.postUpdateNotification()
            }
        }
    }
    
    func getAllBreeds(_ sortedByDate: Bool = true, sortAscending: Bool = true) -> Array<BreedCore> {
        var fetchedResults: Array<BreedCore> = Array<BreedCore>()
        
        // Create request on Breed entity
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: breedEntity)
        
        //Create sort descriptor to sort retrieved Breed by Date, ascending
        if sortedByDate {
            let sortDescriptor = NSSortDescriptor(key: name,
                                                  ascending: sortAscending)
            let sortDescriptors = [sortDescriptor]
            fetchRequest.sortDescriptors = sortDescriptors
        }
        
        //Execute Fetch request
        do {
            fetchedResults = try  self.mainContextInstance.fetch(fetchRequest) as! [BreedCore]
        } catch let fetchError as NSError {
            print("retrieveById error: \(fetchError.localizedDescription)")
            fetchedResults = Array<BreedCore>()
        }
        
        return fetchedResults
    }
    
    func getBreedById(_ bredId: NSString) -> Array<BreedCore> {
        var fetchedResults: Array<BreedCore> = Array<BreedCore>()
        
        // Create request on Breed entity
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: breedEntity)
        
        //Add a predicate to filter by BreedId
        let findByIdPredicate =
            NSPredicate(format: "\(self.idBreed) = %@", bredId)
        fetchRequest.predicate = findByIdPredicate
        
        //Execute Fetch request
        do {
            fetchedResults = try self.mainContextInstance.fetch(fetchRequest) as! [BreedCore]
        } catch let fetchError as NSError {
            print("retrieveById error: \(fetchError.localizedDescription)")
            fetchedResults = Array<BreedCore>()
        }
        
        return fetchedResults
    }
    
    func updateBreed(_ breedItemToUpdate: BreedCore, newBreedItemDetails: Dictionary<String, AnyObject>) {
        
        let minionManagedObjectContextWorker: NSManagedObjectContext =
            NSManagedObjectContext.init(concurrencyType: NSManagedObjectContextConcurrencyType.privateQueueConcurrencyType)
        minionManagedObjectContextWorker.parent = self.mainContextInstance
        
        //Assign field values
        for (key, value) in newBreedItemDetails {
            for attribute in BreedAttributes.getAll {
                if (key == attribute.rawValue) {
                    breedItemToUpdate.setValue(value, forKey: key)
                }
            }
        }
        
        //Persist new Breed to datastore (via Managed Object Context Layer).
        self.persistenceManager.saveWorkerContext(minionManagedObjectContextWorker)
        self.persistenceManager.mergeWithMainContext()
        
        self.postUpdateNotification()
    }
    
    
    func deleteAllBreeds() {
        let retrievedItems = getAllBreeds()
        
        //Delete all Breed items from persistance layer
        for item in retrievedItems {
            self.mainContextInstance.delete(item)
        }
        
        //Save and merge changes from Minion workers with Main context
        self.persistenceManager.mergeWithMainContext()
        
        //Post notification to update datasource of a given Viewcontroller/UITableView
        self.postUpdateNotification()
    }
    
    func deleteBreed(_ breedItem: BreedCore) {
        print(breedItem)
        //Delete Breed item from persistance layer
        self.mainContextInstance.delete(breedItem)
        
        //Save and merge changes from Minion workers with Main context
        self.persistenceManager.mergeWithMainContext()
        
        //Post notification to update datasource of a given Viewcontroller/UITableView
        self.postUpdateNotification()
    }
    
    /**
     Post update notification to let the registered listeners refresh it's datasource.
     
     - Returns: Void
     */
    fileprivate func postUpdateNotification() {
        NotificationCenter.default.post(name: Notification.Name(rawValue: "updateBreedTableData"), object: nil)
    }
    
}
