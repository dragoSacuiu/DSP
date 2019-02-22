//
//  ZoneEntity+CoreDataProperties.swift
//  DSP
//
//  Created by Sacuiu Dragos on 19/02/2019.
//  Copyright © 2019 Sacuiu Dragos. All rights reserved.
//
//

import Foundation
import CoreData


extension ZoneEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ZoneEntity> {
        return NSFetchRequest<ZoneEntity>(entityName: "ZoneEntity")
    }

    @NSManaged public var name: String?
    @NSManaged public var number: Int16
    @NSManaged public var partition: PartitionEntity?

}
