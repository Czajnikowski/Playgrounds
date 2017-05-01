//  Based on: http://www.learncoredata.com/core-data-and-playgrounds/

import CoreData

public class CoreDataStack {
    public let context: NSManagedObjectContext
    public static let sharedInstance: CoreDataStack = CoreDataStack(with: model())
    
    private let persistentStoreCoordinator: NSPersistentStoreCoordinator
    
    public init(with model: NSManagedObjectModel) {
        persistentStoreCoordinator = NSPersistentStoreCoordinator(managedObjectModel: model)
        do {
            try persistentStoreCoordinator.addPersistentStore(
                ofType: NSInMemoryStoreType,
                configurationName: nil,
                at: nil,
                options: nil
            )
        }
        catch {
            print("error creating persistentstorecoordinator: \(error)")
        }

        context = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        context.persistentStoreCoordinator = persistentStoreCoordinator
    }
    
    public func saveContext () {
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                NSLog("Unresolved error \(nserror), \(nserror.userInfo)")
                abort()
            }
        }
    }
}
