//
//  EmiDetailesEntity+CoreDataProperties.swift
//  DSP
//
//  Created by Sacuiu Dragos on 17/02/2019.
//  Copyright © 2019 Sacuiu Dragos. All rights reserved.
//
//

import Foundation
import CoreData


extension EmiDetailesEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<EmiDetailesEntity> {
        return NSFetchRequest<EmiDetailesEntity>(entityName: "EmiDetailesEntity")
    }

    @NSManaged public var date: NSDate?
    @NSManaged public var detailes: String?
    @NSManaged public var user: String?
    @NSManaged public var account: AccountEntity?

}
