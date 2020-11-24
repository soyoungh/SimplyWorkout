//
//  WorkoutDataCD+CoreDataProperties.swift
//  SimplyWorkout
//
//  Created by Soyoung Hyun on 2020/11/21.
//  Copyright © 2020 soyoung hyun. All rights reserved.
//
//

import Foundation
import CoreData


extension WorkoutDataCD {

    @nonobjc public class func createFetchRequest() -> NSFetchRequest<WorkoutDataCD> {
        return NSFetchRequest<WorkoutDataCD>(entityName: "WorkoutDataCD")
    }

    @NSManaged public var activityName: String?
    @NSManaged public var colorTag: String?
    @NSManaged public var created: Date?
    @NSManaged public var detail: String?
    @NSManaged public var duration: String?
    @NSManaged public var effortType: String?
    @NSManaged public var effortValue: Float
    @NSManaged public var location: String?
    @NSManaged public var toEventDate: EventDateCD?

}

extension WorkoutDataCD : Identifiable {

}
