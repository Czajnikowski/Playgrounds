import Foundation

public func populateDatabase(withVolume volume: Int) {
    var contacts = [Contact]()

    (1 ..< volume).forEach { _ in
        contacts.append(
            Contact(
                withName: "Zdzisław",
                surname: "Czapla",
                and: Address(
                    withCity: "Błażowa",
                    state: "Podparpackie",
                    zip: "33-333"
                )
            )
        )
    }

    contacts.append(
        Contact(
            withName: "Wiesław",
            surname: "Mucha",
            and: Address(
                withCity: "Kąkolówka",
                state: "Podparpackie",
                zip: "33-333"
            )
        )
    )
    
    
    try! CoreDataStack.sharedInstance.context.save()
}
