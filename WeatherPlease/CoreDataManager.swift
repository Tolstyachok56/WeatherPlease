//
//  CoreDataManager.swift
//  WeatherPlease
//
//  Created by Виктория Бадисова on 05.02.2018.
//  Copyright © 2018 Виктория Бадисова. All rights reserved.
//

import CoreData

class CoreDataManager {
    
    static let instance = CoreDataManager()
    private init() {}
    
    // Entity for name
    
    func entity(forName entityName: String) -> NSEntityDescription {
        return NSEntityDescription.entity(forEntityName: entityName, in: self.managedObjectContext)!
    }
    
    // Fetched Results Controller for Entity Name
    
    func fetchedResultsController(entityName: String, keyForSort: String) -> NSFetchedResultsController<NSManagedObject> {
        
        let fetchedRequest = NSFetchRequest<NSManagedObject>(entityName: entityName)
        fetchedRequest.sortDescriptors = [NSSortDescriptor(key: keyForSort, ascending: true)]
        
        let fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchedRequest, managedObjectContext: self.managedObjectContext, sectionNameKeyPath: nil, cacheName: nil)
        
        return fetchedResultsController
    }
    
    // MARK: - Core Data stack
    
    lazy var managedObjectContext = self.persistentContainer.viewContext
    
    lazy var persistentContainer: NSPersistentContainer = {
        
        let container = NSPersistentContainer(name: "WeatherPlease")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    // MARK: - Core Data Saving support
    
    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    
}
