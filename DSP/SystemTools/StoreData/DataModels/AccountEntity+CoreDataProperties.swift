//
//  AccountEntity+CoreDataProperties.swift
//  DSP
//
//  Created by Sacuiu Dragos on 12/12/2018.
//  Copyright © 2018 Sacuiu Dragos. All rights reserved.
//
//

import Foundation
import CoreData


extension AccountEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<AccountEntity> {
        return NSFetchRequest<AccountEntity>(entityName: "AccountEntity")
    }

    @NSManaged public var adress1: String?
    @NSManaged public var adress2: String?
    @NSManaged public var city: String?
    @NSManaged public var client: String?
    @NSManaged public var comunicator: String?
    @NSManaged public var contract: String?
    @NSManaged public var county: String?
    @NSManaged public var id: String?
    @NSManaged public var latitude: String?
    @NSManaged public var longitude: String?
    @NSManaged public var name: String?
    @NSManaged public var periodicTest: String?
    @NSManaged public var reciver: String?
    @NSManaged public var sales: String?
    @NSManaged public var system: String?
    @NSManaged public var technic: String?
    @NSManaged public var type: String?
    @NSManaged public var contacts: NSSet?
    @NSManaged public var events: NSSet?
    @NSManaged public var objectiveInfo: NSSet?
    @NSManaged public var partitions: NSSet?
    @NSManaged public var schedeule: ScheduleEntity?
    @NSManaged public var tickets: NSSet?

}

// MARK: Generated accessors for contacts
extension AccountEntity {

    @objc(addContactsObject:)
    @NSManaged public func addToContacts(_ value: ContactEntity)

    @objc(removeContactsObject:)
    @NSManaged public func removeFromContacts(_ value: ContactEntity)

    @objc(addContacts:)
    @NSManaged public func addToContacts(_ values: NSSet)

    @objc(removeContacts:)
    @NSManaged public func removeFromContacts(_ values: NSSet)

}

// MARK: Generated accessors for events
extension AccountEntity {

    @objc(addEventsObject:)
    @NSManaged public func addToEvents(_ value: EventEntity)

    @objc(removeEventsObject:)
    @NSManaged public func removeFromEvents(_ value: EventEntity)

    @objc(addEvents:)
    @NSManaged public func addToEvents(_ values: NSSet)

    @objc(removeEvents:)
    @NSManaged public func removeFromEvents(_ values: NSSet)

}

// MARK: Generated accessors for objectiveInfo
extension AccountEntity {

    @objc(addObjectiveInfoObject:)
    @NSManaged public func addToObjectiveInfo(_ value: ObservationsEntity)

    @objc(removeObjectiveInfoObject:)
    @NSManaged public func removeFromObjectiveInfo(_ value: ObservationsEntity)

    @objc(addObjectiveInfo:)
    @NSManaged public func addToObjectiveInfo(_ values: NSSet)

    @objc(removeObjectiveInfo:)
    @NSManaged public func removeFromObjectiveInfo(_ values: NSSet)

}

// MARK: Generated accessors for partitions
extension AccountEntity {

    @objc(addPartitionsObject:)
    @NSManaged public func addToPartitions(_ value: PartitionEntity)

    @objc(removePartitionsObject:)
    @NSManaged public func removeFromPartitions(_ value: PartitionEntity)

    @objc(addPartitions:)
    @NSManaged public func addToPartitions(_ values: NSSet)

    @objc(removePartitions:)
    @NSManaged public func removeFromPartitions(_ values: NSSet)

}

// MARK: Generated accessors for tickets
extension AccountEntity {

    @objc(addTicketsObject:)
    @NSManaged public func addToTickets(_ value: TicketEntity)

    @objc(removeTicketsObject:)
    @NSManaged public func removeFromTickets(_ value: TicketEntity)

    @objc(addTickets:)
    @NSManaged public func addToTickets(_ values: NSSet)

    @objc(removeTickets:)
    @NSManaged public func removeFromTickets(_ values: NSSet)

}
