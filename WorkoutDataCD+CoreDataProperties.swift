//
//  WorkoutDataCD+CoreDataProperties.swift
//  SimplyWorkout
//
//  Created by Soyoung Hyun on 2020/09/01.
//  Copyright © 2020 soyoung hyun. All rights reserved.
//
//

import Foundation
import CoreData


extension WorkoutDataCD {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<WorkoutDataCD> {
        return NSFetchRequest<WorkoutDataCD>(entityName: "WorkoutDataCD")
    }

    @NSManaged public var created: Date?
    @NSManaged public var activityName: String?
    @NSManaged public var detail: String?
    @NSManaged public var duration: String?
    @NSManaged public var effortType: String?
    @NSManaged public var effortValue: Float
    @NSManaged public var colorTag: String?
    @NSManaged public var toEventDate: EventDateCD?

}
