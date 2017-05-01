import Foundation
import CoreData

public class Contact: NSManagedObject {
    @NSManaged public var name: String
    @NSManaged public var surname: String
    
    @NSManaged public var addresses: Set<Address>
    
    public init(withName name: String, surname: String, and address: Address) {
        super.init(
            entity: Contact.entityDescription,
            insertInto: CoreDataStack.sharedInstance.context
        )
        
        self.name = name
        self.surname = surname
        self.addresses = Set(arrayLiteral: address)
    }
}

extension Contact {
    static let entityDescription: NSEntityDescription = {
        let entity = NSEntityDescription()
        
        let contactString = NSStringFromClass(Contact.self)
        
        entity.name = contactString
        entity.managedObjectClassName = contactString
        
        let contactToAddressRelations = NSRelationshipDescription()
        contactToAddressRelations.name = "addresses"
        contactToAddressRelations.destinationEntity = Address.entityDescription
        contactToAddressRelations.minCount = 1
        contactToAddressRelations.maxCount = 0
        
        entity.properties = ["name", "surname"].map { $0.stringProperty } + [contactToAddressRelations]
        
        return entity
    }()
}
