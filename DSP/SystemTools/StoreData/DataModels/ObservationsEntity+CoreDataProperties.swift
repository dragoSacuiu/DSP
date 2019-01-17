//
//  ObservationsEntity+CoreDataProperties.swift
//  DSP
//
//  Created by Sacuiu Dragos on 04/12/2018.
//  Copyright © 2018 Sacuiu Dragos. All rights reserved.
//
//

import Foundation
import CoreData


extension ObservationsEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ObservationsEntity> {
        return NSFetchRequest<ObservationsEntity>(entityName: "ObservationsEntity")
    }

    @NSManaged public var date: String?
    @NSManaged public var observation: String?
    @NSManaged public var user: String?
    @NSManaged public var objective: AccountEntity?

}
