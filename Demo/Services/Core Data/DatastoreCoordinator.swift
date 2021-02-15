//
//  DatastoreCoordinator.swift
//  Demo
//
//  Created by Julio Lemus on 13/02/21.
//

import Foundation
import CoreData
 
class DatastoreCoordinator: NSObject {

    fileprivate let objectModelName = "BDLocal"
    fileprivate let objectModelExtension = "momd"
    fileprivate let dbFilename = "SingleViewCoreData.sqlite"
    fileprivate let appDomain = "com.gt.demoApp"

    override init() {
        super.init()
    }

    // MARK: - Core Data stack

    lazy var applicationDocumentsDirectory: URL = {
        let urls = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)

        return urls[urls.count-1]
    }()

    //
    lazy var managedObjectModel: NSManagedObjectModel = {
        let modelURL = Bundle.main.url(forResource: self.objectModelName, withExtension: self.objectModelExtension)!

        return NSManagedObjectModel(contentsOf: modelURL)!
    }()

    //
    lazy var persistentStoreCoordinator: NSPersistentStoreCoordinator = { 
        let coordinator = NSPersistentStoreCoordinator(managedObjectModel: self.managedObjectModel)
        let url = self.applicationDocumentsDirectory.appendingPathComponent(self.dbFilename)
        var failureReason = "There was an error creating or loading the application's saved data."

        do {
            try coordinator.addPersistentStore(ofType: NSSQLiteStoreType, configurationName: nil, at: url, options: nil)
        } catch {
            // Report any error we got.
            var dict = [String: AnyObject]()
            dict[NSLocalizedDescriptionKey] = "Failed to initialize the application's saved data" as AnyObject?
            dict[NSLocalizedFailureReasonErrorKey] = failureReason as AnyObject?

            dict[NSUnderlyingErrorKey] = error as NSError
            let wrappedError = NSError(domain: self.appDomain, code: 9999, userInfo: dict)
            // Replace this with code to handle the error appropriately.
            NSLog("Unresolved error \(wrappedError), \(wrappedError.userInfo)")

            abort()
        }

        return coordinator
    }()
}
