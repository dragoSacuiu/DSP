//
//  EventMO+CoreDataProperties.swift
//  DSP
//
//  Created by Sacuiu Dragos on 15/09/2018.
//  Copyright © 2018 Sacuiu Dragos. All rights reserved.
//
//

import Foundation
import CoreData


extension EventMO {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<EventMO> {
        return NSFetchRequest<EventMO>(entityName: "EventMO")
    }

    @NSManaged public var cid: String?
    @NSManaged public var date: String?
    @NSManaged public var eventName: String?
    @NSManaged public var eventType: String?
    @NSManaged public var group: String?
    @NSManaged public var partition: String?
    @NSManaged public var zoneOrUser: String?
    @NSManaged public var account: AccountMO?

}
