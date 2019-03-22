//
//  AccountEntity+CoreDataProperties.swift
//  DSP
//
//  Created by Sacuiu Dragos on 22/03/2019.
//  Copyright © 2019 Sacuiu Dragos. All rights reserved.
//
//

import Foundation
import CoreData


extension AccountEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<AccountEntity> {
        return NSFetchRequest<AccountEntity>(entityName: "AccountEntity")
    }

    @NSManaged public var active: Bool
    @NSManaged public var client: String?
    @NSManaged public var comunicator: String?
    @NSManaged public var contract: String?
    @NSManaged public var id: String?
    @NSManaged public var objective: String?
    @NSManaged public var periodicTest: String?
    @NSManaged public var sales: String?
    @NSManaged public var status: String?
    @NSManaged public var system: String?
    @NSManaged public var technic: String?
    @NSManaged public var type: String?
    @NSManaged public var manager: String?
    @NSManaged public var actionDetailes: NSSet?
    @NSManaged public var contacts: NSSet?
    @NSManaged public var emiDetails: NSSet?
    @NSManaged public var events: NSSet?
    @NSManaged public var location: AccountLocationEntity?
    @NSManaged public var observations: NSSet?
    @NSManaged public var partitions: NSSet?
    @NSManaged public var schedeule: ScheduleEntity?
    @NSManaged public var tickets: NSSet?

}

// MARK: Generated accessors for actionDetailes
extension AccountEntity {

    @objc(addActionDetailesObject:)
    @NSManaged public func addToActionDetailes(_ value: ActionDetailesEntity)

    @objc(removeActionDetailesObject:)
    @NSManaged public func removeFromActionDetailes(_ value: ActionDetailesEntity)

    @objc(addActionDetailes:)
    @NSManaged public func addToActionDetailes(_ values: NSSet)

    @objc(removeActionDetailes:)
    @NSManaged public func removeFromActionDetailes(_ values: NSSet)

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

// MARK: Generated accessors for emiDetails
extension AccountEntity {

    @objc(addEmiDetailsObject:)
    @NSManaged public func addToEmiDetails(_ value: EmiDetailesEntity)

    @objc(removeEmiDetailsObject:)
    @NSManaged public func removeFromEmiDetails(_ value: EmiDetailesEntity)

    @objc(addEmiDetails:)
    @NSManaged public func addToEmiDetails(_ values: NSSet)

    @objc(removeEmiDetails:)
    @NSManaged public func removeFromEmiDetails(_ values: NSSet)

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

// MARK: Generated accessors for observations
extension AccountEntity {

    @objc(addObservationsObject:)
    @NSManaged public func addToObservations(_ value: ObservationsEntity)

    @objc(removeObservationsObject:)
    @NSManaged public func removeFromObservations(_ value: ObservationsEntity)

    @objc(addObservations:)
    @NSManaged public func addToObservations(_ values: NSSet)

    @objc(removeObservations:)
    @NSManaged public func removeFromObservations(_ values: NSSet)

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
