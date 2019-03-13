//
//  CoreDataManager.swift
//  DSP
//
//  Created by Sacuiu Dragos on 15/09/2018.
//  Copyright © 2018 Sacuiu Dragos. All rights reserved.
//

import Foundation
import CoreData

final class CoreDataManager {
    private let modelName: String
    
    init(dataModelName: String) {
        self.modelName = dataModelName
    }
    
    lazy var managedObjectModel: NSManagedObjectModel = {
        let modelURL = Bundle.main.url(forResource: self.modelName, withExtension: ".momd")
        return NSManagedObjectModel.init(contentsOf: modelURL!)!
    }()
    
    lazy var dataBaseDirectory = URL(fileURLWithPath: "/Volumes/home/DSP/DSP/SystemTools/StoreData/DataBase")
    
    lazy var persistentStoreCoordinator: NSPersistentStoreCoordinator = {
        let coordinator = NSPersistentStoreCoordinator(managedObjectModel: managedObjectModel)
        let persistentStoreURL = dataBaseDirectory.appendingPathExtension("\(modelName).sqlite")
        
        do {
            try coordinator.addPersistentStore(ofType: "SQLite", configurationName: nil, at: persistentStoreURL, options: [NSMigratePersistentStoresAutomaticallyOption: true, NSInferMappingModelAutomaticallyOption: true ])
        } catch {
            fatalError("Cannot add persistent store")
        }
        return coordinator
    }()
    
    lazy var managedObjectContext: NSManagedObjectContext = {
        let managedObjectContext = NSManagedObjectContext.init(concurrencyType: .mainQueueConcurrencyType )
        managedObjectContext.persistentStoreCoordinator = self.persistentStoreCoordinator
        return managedObjectContext
    }()
    lazy var backgroundContext: NSManagedObjectContext = {
        let managedObgectContext = NSManagedObjectContext.init(concurrencyType: .privateQueueConcurrencyType)
        managedObgectContext.persistentStoreCoordinator = self.persistentStoreCoordinator
        return managedObgectContext
    }()
}
