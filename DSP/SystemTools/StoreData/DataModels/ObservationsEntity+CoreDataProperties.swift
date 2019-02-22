//
//  ObservationsEntity+CoreDataProperties.swift
//  DSP
//
//  Created by Sacuiu Dragos on 18/02/2019.
//  Copyright © 2019 Sacuiu Dragos. All rights reserved.
//
//

import Foundation
import CoreData


extension ObservationsEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ObservationsEntity> {
        return NSFetchRequest<ObservationsEntity>(entityName: "ObservationsEntity")
    }

    @NSManaged public var date: NSDate?
    @NSManaged public var observation: String?
    @NSManaged public var user: String?
    @NSManaged public var account: AccountEntity?

}
