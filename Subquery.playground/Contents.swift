import Foundation
import CoreData

let searchQuery = "Kąkolówka"
let context = CoreDataStack.sharedInstance.context
let fetchRequest = NSFetchRequest<Contact>(entityName: Contact.entity().name!)

populateDatabase(withVolume: 5000)

print("Fetch and filter:")
benchmark {
    var results = try! context.fetch(fetchRequest)
    results = results.filter {
        $0.addresses.contains(
            where: {
                $0.city == searchQuery
            }
        )
    }
}

print("\nFetch with a block:")
fetchRequest.predicate = NSPredicate(
    block: { addresses, _ in
        let addresses = addresses.nsObject.value(forKey: "addresses") as! Array<Any?>
        return addresses.contains(
            where: { address in
                return (address.nsObject.value(forKey: "city") as! String) == searchQuery
            }
        )
    }
)

benchmark {
    let results = try! context.fetch(fetchRequest)
}

print("\nFetch with a SUBQUERY:")
fetchRequest.predicate = NSPredicate(
    format: "SUBQUERY(" +
        "addresses, " +
        "$address, " +
        "$address.city ==[cd] \"\(searchQuery)\"" +
    ").@count > 0"
)

var results = [Contact]()
benchmark {
    var results = try! context.fetch(fetchRequest)
}
