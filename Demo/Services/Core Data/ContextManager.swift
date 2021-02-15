//
//  ContextManager.swift
//  Demo
//
//  Created by Julio Lemus on 13/02/21.
//
 
import Foundation
import CoreData
 
class ContextManager: NSObject {

    let datastore: DatastoreCoordinator!

    override init() {
        let appDelegate: AppDelegate = AppDelegate().sharedInstance()
        self.datastore = appDelegate.datastoreCoordinator
        super.init()
    }
 
    lazy var masterManagedObjectContextInstance: NSManagedObjectContext = {
        var masterManagedObjectContext = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
        masterManagedObjectContext.persistentStoreCoordinator = self.datastore.persistentStoreCoordinator

        return masterManagedObjectContext
    }()
 
    lazy var mainManagedObjectContextInstance: NSManagedObjectContext = {
        var mainManagedObjectContext = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        mainManagedObjectContext.persistentStoreCoordinator = self.datastore.persistentStoreCoordinator

        return mainManagedObjectContext
    }()
 
    func saveContext() {
        defer {
            do {
                try masterManagedObjectContextInstance.save()
            } catch let masterMocSaveError as NSError {
                print("Master Managed Object Context save error: \(masterMocSaveError.localizedDescription)")
            } catch {
                print("Master Managed Object Context save error.")
            }
        }

        if mainManagedObjectContextInstance.hasChanges {
            mergeChangesFromMainContext()
        }
    }
 
    fileprivate func mergeChangesFromMainContext() {
        DispatchQueue.main.async(execute: {
            do {
                try self.mainManagedObjectContextInstance.save()
            } catch let mocSaveError as NSError {
                print("Master Managed Object Context error: \(mocSaveError.localizedDescription)")
            }
        })
    }

}
