//
//  ScheduleMO+CoreDataProperties.swift
//  DSP
//
//  Created by Sacuiu Dragos on 15/09/2018.
//  Copyright © 2018 Sacuiu Dragos. All rights reserved.
//
//

import Foundation
import CoreData


extension ScheduleMO {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ScheduleMO> {
        return NSFetchRequest<ScheduleMO>(entityName: "ScheduleMO")
    }

    @NSManaged public var monday: String?
    @NSManaged public var tuesday: String?
    @NSManaged public var thursday: String?
    @NSManaged public var wednesday: String?
    @NSManaged public var friday: String?
    @NSManaged public var saturday: String?
    @NSManaged public var sunday: String?
    @NSManaged public var objective: ObjectiveMO?

}
