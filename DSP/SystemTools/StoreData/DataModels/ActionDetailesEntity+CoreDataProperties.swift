//
//  ActionDetailesEntity+CoreDataProperties.swift
//  DSP
//
//  Created by Sacuiu Dragos on 17/02/2019.
//  Copyright © 2019 Sacuiu Dragos. All rights reserved.
//
//

import Foundation
import CoreData


extension ActionDetailesEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ActionDetailesEntity> {
        return NSFetchRequest<ActionDetailesEntity>(entityName: "ActionDetailesEntity")
    }

    @NSManaged public var date: NSDate?
    @NSManaged public var detailes: String?
    @NSManaged public var user: String?
    @NSManaged public var account: AccountEntity?

}
