//
//  ScheduleEntity+CoreDataProperties.swift
//  DSP
//
//  Created by Sacuiu Dragos on 04/12/2018.
//  Copyright © 2018 Sacuiu Dragos. All rights reserved.
//
//

import Foundation
import CoreData


extension ScheduleEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ScheduleEntity> {
        return NSFetchRequest<ScheduleEntity>(entityName: "ScheduleEntity")
    }

    @NSManaged public var friday: String?
    @NSManaged public var monday: String?
    @NSManaged public var saturday: String?
    @NSManaged public var sunday: String?
    @NSManaged public var thursday: String?
    @NSManaged public var tuesday: String?
    @NSManaged public var wednesday: String?
    @NSManaged public var objective: AccountEntity?

}
