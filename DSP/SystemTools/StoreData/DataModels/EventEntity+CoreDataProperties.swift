//
//  EventEntity+CoreDataProperties.swift
//  DSP
//
//  Created by Sacuiu Dragos on 04/03/2019.
//  Copyright © 2019 Sacuiu Dragos. All rights reserved.
//
//

import Foundation
import CoreData


extension EventEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<EventEntity> {
        return NSFetchRequest<EventEntity>(entityName: "EventEntity")
    }

    @NSManaged public var cid: String?
    @NSManaged public var date: NSDate?
    @NSManaged public var eventName: String?
    @NSManaged public var group: Int16
    @NSManaged public var partition: Int16
    @NSManaged public var priority: Int16
    @NSManaged public var zoneOrUser: Int16
    @NSManaged public var account: AccountEntity?

}
