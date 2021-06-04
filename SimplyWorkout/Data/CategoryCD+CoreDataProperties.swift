//
//  CategoryCD+CoreDataProperties.swift
//  
//
//  Created by Soyoung Hyun on 2021/06/04.
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
    @NSManaged public var isNotified: Bool
    @NSManaged public var location: String?
    @NSManaged public var frequency: String?
    @NSManaged public var preSet_details: String?

}
