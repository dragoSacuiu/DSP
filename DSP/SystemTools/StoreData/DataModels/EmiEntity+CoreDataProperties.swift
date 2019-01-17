//
//  EmiEntity+CoreDataProperties.swift
//  DSP
//
//  Created by Sacuiu Dragos on 04/12/2018.
//  Copyright © 2018 Sacuiu Dragos. All rights reserved.
//
//

import Foundation
import CoreData


extension EmiEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<EmiEntity> {
        return NSFetchRequest<EmiEntity>(entityName: "EmiEntity")
    }

    @NSManaged public var id: String?
    @NSManaged public var phone: String?

}
