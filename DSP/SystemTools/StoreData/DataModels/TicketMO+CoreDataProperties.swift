//
//  TicketMO+CoreDataProperties.swift
//  DSP
//
//  Created by Sacuiu Dragos on 15/09/2018.
//  Copyright © 2018 Sacuiu Dragos. All rights reserved.
//
//

import Foundation
import CoreData


extension TicketMO {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<TicketMO> {
        return NSFetchRequest<TicketMO>(entityName: "TicketMO")
    }

    @NSManaged public var content: String?
    @NSManaged public var coordinator: String?
    @NSManaged public var date: String?
    @NSManaged public var number: String?
    @NSManaged public var type: String?
    @NSManaged public var user: String?
    @NSManaged public var objective: ObjectiveMO?

}
