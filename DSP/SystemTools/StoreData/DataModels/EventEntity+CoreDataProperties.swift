//
//  EventEntity+CoreDataProperties.swift
//  DSP
//
//  Created by Sacuiu Dragos on 25/01/2019.
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
    @NSManaged public var date: String?
    @NSManaged public var eventName: String?
    @NSManaged public var group: String?
    @NSManaged public var partition: String?
    @NSManaged public var zoneOrUser: String?
    @NSManaged public var priority: Int16
    @NSManaged public var account: AccountEntity?

}
