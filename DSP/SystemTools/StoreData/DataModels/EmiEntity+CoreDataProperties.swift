//
//  EmiEntity+CoreDataProperties.swift
//  DSP
//
//  Created by Sacuiu Dragos on 12/03/2019.
//  Copyright © 2019 Sacuiu Dragos. All rights reserved.
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
    @NSManaged public var longitude: Double
    @NSManaged public var latitude: Double
    @NSManaged public var active: Bool
    @NSManaged public var statusDetails: String?

}
