//
//  InterventionMO+CoreDataProperties.swift
//  DSP
//
//  Created by Sacuiu Dragos on 15/09/2018.
//  Copyright © 2018 Sacuiu Dragos. All rights reserved.
//
//

import Foundation
import CoreData


extension InterventionMO {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<InterventionMO> {
        return NSFetchRequest<InterventionMO>(entityName: "InterventionMO")
    }

    @NSManaged public var id: String?
    @NSManaged public var phone: String?

}
