//
//  MSOfflineManager.swift
//  MovieSample
//
//  Created by Govind Sah on 06/07/19.
//  Copyright © 2019 Govind Sah. All rights reserved.
//

import UIKit
import CoreData

class MSOfflineManager: NSObject {
    
    static let shared = MSOfflineManager()

    // Dependency Injecting persistentContainer
    struct Config {
        var persistentContainer: NSPersistentContainer
    }
    
    private static var config: Config?

    class func setup(_ config: Config){
        MSOfflineManager.config = config
    }

    private override init() {
        guard let _ = MSOfflineManager.config else {
            print("Using Default PersistentContainer from AppDelegate")
            MSOfflineManager.setup(Config(persistentContainer: (UIApplication.shared.delegate as! MSAppDelegate).persistentContainer))
            return
        }
    }
    
}

// MARK: - Accessing local db

extension MSOfflineManager {
    
    /// to fetch all the model objects of type A from the local db
    /// remember to call -save on it finally
    func fetchFromStorage<A>() throws -> [A]? where A: NSManagedObject {
        if let managedObjectContext = MSOfflineManager.config?.persistentContainer.viewContext {
            let fetchRequest = NSFetchRequest<A>(entityName: A.className)
            do {
                let tracks = try managedObjectContext.fetch(fetchRequest)
                return tracks
            } catch let error {
                print(error)
                throw error
            }
        } else {
            return nil
        }
    }
    
    /// to remove all the model objects of type A from the local db
    /// remember to call -save on it finally
    func removeFromStorage<A>(type: A.Type) throws where A: NSManagedObject {
        if let managedObjectContext = MSOfflineManager.config?.persistentContainer.viewContext {
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: A.className)
            do {
                let batchDeleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
                do {
                    try managedObjectContext.execute(batchDeleteRequest)
                } catch let error as NSError {
                    print(error)
                    throw error
                }
            } catch let error {
                print(error)
                throw error
            }
        } else {
            fatalError("Cant find the Managed Object Context")
        }
    }

}
