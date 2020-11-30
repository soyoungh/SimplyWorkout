//
//  CategoryCD+CoreDataProperties.swift
//  SimplyWorkout
//
//  Created by Soyoung Hyun on 2020/10/27.
//  Copyright © 2020 soyoung hyun. All rights reserved.
//
//

import Foundation
import CoreData


extension CategoryCD {

    @nonobjc public class func createFetchRequest() -> NSFetchRequest<CategoryCD> {
        return NSFetchRequest<CategoryCD>(entityName: "CategoryCD")
    }

    @NSManaged public var activityName_c: String?
    @NSManaged public var colorTag_c: String?
    @NSManaged public var index: Int16
}
