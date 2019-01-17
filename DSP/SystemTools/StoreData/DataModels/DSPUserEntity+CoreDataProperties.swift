//
//  DSPUserEntity+CoreDataProperties.swift
//  DSP
//
//  Created by Sacuiu Dragos on 04/12/2018.
//  Copyright © 2018 Sacuiu Dragos. All rights reserved.
//
//

import Foundation
import CoreData


extension DSPUserEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<DSPUserEntity> {
        return NSFetchRequest<DSPUserEntity>(entityName: "DSPUserEntity")
    }

    @NSManaged public var name: String?
    @NSManaged public var password: String?

}
