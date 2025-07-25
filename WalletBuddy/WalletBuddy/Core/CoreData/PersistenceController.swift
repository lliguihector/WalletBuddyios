//
//  PersistenceController.swift
//  WalletBuddy
//
//  Created by Hector Lliguichuzca on 7/23/25.
//
import CoreData

struct PersistenceController{
    
static let shared = PersistenceController()
    
    let container: NSPersistentContainer
    
    
    init(inMemory: Bool = false){
        
        container = NSPersistentContainer(name: "WalletBuddy") //Use your xcdatamodel file name here
        if inMemory {
            container.persistentStoreDescriptions.first?.url = URL(fileURLWithPath: "/dev/null")
        }

            container.loadPersistentStores{ description, error in
            
            if let error = error as NSError?{
                fatalError("Unresolved error \(error),\(error.userInfo)")
            }}
        
    }
    
    var context: NSManagedObjectContext{
        container.viewContext
    }
    
}
