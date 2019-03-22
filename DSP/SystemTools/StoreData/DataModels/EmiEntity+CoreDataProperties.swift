//
//  EmiEntity+CoreDataProperties.swift
//  DSP
//
//  Created by Sacuiu Dragos on 20/03/2019.
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
    @NSManaged public var latitude: Double
    @NSManaged public var longitude: Double
    @NSManaged public var phone: String?
    @NSManaged public var status: String?
    @NSManaged public var statusDetails: String?
    @NSManaged public var distance: Double

}
