import Foundation
import CoreData

public class Address: NSManagedObject {
    @NSManaged public var city: String
    @NSManaged public var state: String
    @NSManaged public var zip: String
    
    public init(withCity city: String, state: String, zip: String) {
        super.init(
            entity: Address.entityDescription,
            insertInto: CoreDataStack.sharedInstance.context
        )
        
        self.city = city
        self.state = state
        self.zip = zip
    }
}

extension Address {
    static let entityDescription: NSEntityDescription = {
        let entity = NSEntityDescription()
        
        let addressString = NSStringFromClass(Address.self)
        
        entity.name = addressString
        entity.managedObjectClassName = addressString
        
        entity.properties = ["city", "state", "zip"].map { $0.stringProperty }
        
        return entity
    }()
}
