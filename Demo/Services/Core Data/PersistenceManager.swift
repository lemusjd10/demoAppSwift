//
//  PersistenceManager.swift
//  Demo
//
//  Created by Julio Lemus on 13/02/21.
//

import Foundation
import CoreData

class PersistenceManager: NSObject {
    
    fileprivate var appDelegate: AppDelegate
    fileprivate var mainContextInstance: NSManagedObjectContext
    
    class var sharedInstance: PersistenceManager {
        struct Singleton {
            static let instance = PersistenceManager()
        }
        
        return Singleton.instance
    }
    
    override init() {
        appDelegate = AppDelegate().sharedInstance()
        mainContextInstance = ContextManager.init().mainManagedObjectContextInstance
        super.init()
    }
    
    func getMainContextInstance() -> NSManagedObjectContext {
        return self.mainContextInstance
    }
    
    func saveWorkerContext(_ workerContext: NSManagedObjectContext) {
        do {
            try workerContext.save()
        } catch let saveError as NSError {
            print("save minion worker error: \(saveError.localizedDescription)")
        }
    }
    
    func mergeWithMainContext() {
        do {
            try self.mainContextInstance.save()
        } catch let saveError as NSError {
            print("synWithMainContext error: \(saveError.localizedDescription)")
        }
    }
    
}
