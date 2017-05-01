import Foundation
import CoreData

public func model() -> NSManagedObjectModel {
    let model = NSManagedObjectModel()
    model.entities = [Address.entityDescription, Contact.entityDescription]
    
    return model
}

extension String {
    public var stringProperty: NSPropertyDescription {
        let property = NSAttributeDescription()
        
        property.name = self.lowercased()
        property.attributeType = .stringAttributeType
        property.isOptional = false
        property.isIndexed = false
        
        return property
    }
}
