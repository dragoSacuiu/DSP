//
//  ObjectiveMO+CoreDataProperties.swift
//  DSP
//
//  Created by Sacuiu Dragos on 15/09/2018.
//  Copyright © 2018 Sacuiu Dragos. All rights reserved.
//
//

import Foundation
import CoreData


extension ObjectiveMO {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ObjectiveMO> {
        return NSFetchRequest<ObjectiveMO>(entityName: "ObjectiveMO")
    }

    @NSManaged public var name: String?
    @NSManaged public var accounts: NSSet?
    @NSManaged public var adress: AdressMO?
    @NSManaged public var clinet: ClientMO?
    @NSManaged public var contacts: NSSet?
    @NSManaged public var objectiveInfo: NSSet?
    @NSManaged public var partitions: NSSet?
    @NSManaged public var schedeule: ScheduleMO?
    @NSManaged public var tehnicalInfo: NSSet?
    @NSManaged public var tickets: NSSet?

}

// MARK: Generated accessors for accounts
extension ObjectiveMO {

    @objc(addAccountsObject:)
    @NSManaged public func addToAccounts(_ value: AccountMO)

    @objc(removeAccountsObject:)
    @NSManaged public func removeFromAccounts(_ value: AccountMO)

    @objc(addAccounts:)
    @NSManaged public func addToAccounts(_ values: NSSet)

    @objc(removeAccounts:)
    @NSManaged public func removeFromAccounts(_ values: NSSet)

}

// MARK: Generated accessors for contacts
extension ObjectiveMO {

    @objc(addContactsObject:)
    @NSManaged public func addToContacts(_ value: ContactMO)

    @objc(removeContactsObject:)
    @NSManaged public func removeFromContacts(_ value: ContactMO)

    @objc(addContacts:)
    @NSManaged public func addToContacts(_ values: NSSet)

    @objc(removeContacts:)
    @NSManaged public func removeFromContacts(_ values: NSSet)

}

// MARK: Generated accessors for objectiveInfo
extension ObjectiveMO {

    @objc(addObjectiveInfoObject:)
    @NSManaged public func addToObjectiveInfo(_ value: ObjectiveInfoMO)

    @objc(removeObjectiveInfoObject:)
    @NSManaged public func removeFromObjectiveInfo(_ value: ObjectiveInfoMO)

    @objc(addObjectiveInfo:)
    @NSManaged public func addToObjectiveInfo(_ values: NSSet)

    @objc(removeObjectiveInfo:)
    @NSManaged public func removeFromObjectiveInfo(_ values: NSSet)

}

// MARK: Generated accessors for partitions
extension ObjectiveMO {

    @objc(addPartitionsObject:)
    @NSManaged public func addToPartitions(_ value: PartitionMO)

    @objc(removePartitionsObject:)
    @NSManaged public func removeFromPartitions(_ value: PartitionMO)

    @objc(addPartitions:)
    @NSManaged public func addToPartitions(_ values: NSSet)

    @objc(removePartitions:)
    @NSManaged public func removeFromPartitions(_ values: NSSet)

}

// MARK: Generated accessors for tehnicalInfo
extension ObjectiveMO {

    @objc(addTehnicalInfoObject:)
    @NSManaged public func addToTehnicalInfo(_ value: TehnicalInfoMO)

    @objc(removeTehnicalInfoObject:)
    @NSManaged public func removeFromTehnicalInfo(_ value: TehnicalInfoMO)

    @objc(addTehnicalInfo:)
    @NSManaged public func addToTehnicalInfo(_ values: NSSet)

    @objc(removeTehnicalInfo:)
    @NSManaged public func removeFromTehnicalInfo(_ values: NSSet)

}

// MARK: Generated accessors for tickets
extension ObjectiveMO {

    @objc(addTicketsObject:)
    @NSManaged public func addToTickets(_ value: TicketMO)

    @objc(removeTicketsObject:)
    @NSManaged public func removeFromTickets(_ value: TicketMO)

    @objc(addTickets:)
    @NSManaged public func addToTickets(_ values: NSSet)

    @objc(removeTickets:)
    @NSManaged public func removeFromTickets(_ values: NSSet)

}
