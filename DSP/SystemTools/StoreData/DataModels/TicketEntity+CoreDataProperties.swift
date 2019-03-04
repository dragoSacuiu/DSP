//
//  TicketEntity+CoreDataProperties.swift
//  DSP
//
//  Created by Sacuiu Dragos on 04/03/2019.
//  Copyright © 2019 Sacuiu Dragos. All rights reserved.
//
//

import Foundation
import CoreData


extension TicketEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<TicketEntity> {
        return NSFetchRequest<TicketEntity>(entityName: "TicketEntity")
    }

    @NSManaged public var content: String?
    @NSManaged public var date: NSDate?
    @NSManaged public var manager: String?
    @NSManaged public var number: Int64
    @NSManaged public var status: String?
    @NSManaged public var type: String?
    @NSManaged public var user: String?
    @NSManaged public var account: AccountEntity?

}
