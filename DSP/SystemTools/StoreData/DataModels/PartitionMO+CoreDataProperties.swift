//
//  PartitionMO+CoreDataProperties.swift
//  DSP
//
//  Created by Sacuiu Dragos on 15/09/2018.
//  Copyright © 2018 Sacuiu Dragos. All rights reserved.
//
//

import Foundation
import CoreData


extension PartitionMO {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<PartitionMO> {
        return NSFetchRequest<PartitionMO>(entityName: "PartitionMO")
    }

    @NSManaged public var number: Int16
    @NSManaged public var name: String?
    @NSManaged public var objective: ObjectiveMO?
    @NSManaged public var zones: NSSet?

}

// MARK: Generated accessors for zones
extension PartitionMO {

    @objc(addZonesObject:)
    @NSManaged public func addToZones(_ value: ZoneMO)

    @objc(removeZonesObject:)
    @NSManaged public func removeFromZones(_ value: ZoneMO)

    @objc(addZones:)
    @NSManaged public func addToZones(_ values: NSSet)

    @objc(removeZones:)
    @NSManaged public func removeFromZones(_ values: NSSet)

}
