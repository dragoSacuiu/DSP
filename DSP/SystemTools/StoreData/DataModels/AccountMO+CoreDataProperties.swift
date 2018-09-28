//
//  AccountMO+CoreDataProperties.swift
//  DSP
//
//  Created by Sacuiu Dragos on 15/09/2018.
//  Copyright © 2018 Sacuiu Dragos. All rights reserved.
//
//

import Foundation
import CoreData


extension AccountMO {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<AccountMO> {
        return NSFetchRequest<AccountMO>(entityName: "AccountMO")
    }

    @NSManaged public var id: String?
    @NSManaged public var events: NSSet?
    @NSManaged public var objective: ObjectiveMO?

}

// MARK: Generated accessors for events
extension AccountMO {

    @objc(addEventsObject:)
    @NSManaged public func addToEvents(_ value: EventMO)

    @objc(removeEventsObject:)
    @NSManaged public func removeFromEvents(_ value: EventMO)

    @objc(addEvents:)
    @NSManaged public func addToEvents(_ values: NSSet)

    @objc(removeEvents:)
    @NSManaged public func removeFromEvents(_ values: NSSet)

}
