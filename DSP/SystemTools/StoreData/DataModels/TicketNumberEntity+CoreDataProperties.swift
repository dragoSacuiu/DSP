//
//  TicketNumberEntity+CoreDataProperties.swift
//  DSP
//
//  Created by Sacuiu Dragos on 20/02/2019.
//  Copyright © 2019 Sacuiu Dragos. All rights reserved.
//
//

import Foundation
import CoreData


extension TicketNumberEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<TicketNumberEntity> {
        return NSFetchRequest<TicketNumberEntity>(entityName: "TicketNumberEntity")
    }

    @NSManaged public var number: Int64

}
