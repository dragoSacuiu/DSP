//
//  PartitionEntity+CoreDataProperties.swift
//  DSP
//
//  Created by Sacuiu Dragos on 12/12/2018.
//  Copyright © 2018 Sacuiu Dragos. All rights reserved.
//
//

import Foundation
import CoreData


extension PartitionEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<PartitionEntity> {
        return NSFetchRequest<PartitionEntity>(entityName: "PartitionEntity")
    }

    @NSManaged public var name: String?
    @NSManaged public var number: Int16
    @NSManaged public var account: AccountEntity?
    @NSManaged public var zones: NSSet?

}

// MARK: Generated accessors for zones
extension PartitionEntity {

    @objc(addZonesObject:)
    @NSManaged public func addToZones(_ value: ZoneEntity)

    @objc(removeZonesObject:)
    @NSManaged public func removeFromZones(_ value: ZoneEntity)

    @objc(addZones:)
    @NSManaged public func addToZones(_ values: NSSet)

    @objc(removeZones:)
    @NSManaged public func removeFromZones(_ values: NSSet)

}
