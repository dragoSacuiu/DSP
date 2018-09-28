//
//  ZoneMO+CoreDataProperties.swift
//  DSP
//
//  Created by Sacuiu Dragos on 15/09/2018.
//  Copyright © 2018 Sacuiu Dragos. All rights reserved.
//
//

import Foundation
import CoreData


extension ZoneMO {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ZoneMO> {
        return NSFetchRequest<ZoneMO>(entityName: "ZoneMO")
    }

    @NSManaged public var number: Int16
    @NSManaged public var name: String?
    @NSManaged public var partition: PartitionMO?

}
