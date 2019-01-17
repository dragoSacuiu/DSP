//
//  TicketEntity+CoreDataProperties.swift
//  DSP
//
//  Created by Sacuiu Dragos on 04/12/2018.
//  Copyright © 2018 Sacuiu Dragos. All rights reserved.
//
//

import Foundation
import CoreData


extension TicketEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<TicketEntity> {
        return NSFetchRequest<TicketEntity>(entityName: "TicketEntity")
    }

    @NSManaged public var content: String?
    @NSManaged public var date: String?
    @NSManaged public var manager: String?
    @NSManaged public var number: String?
    @NSManaged public var state: String?
    @NSManaged public var type: String?
    @NSManaged public var user: String?
    @NSManaged public var objective: AccountEntity?

}
