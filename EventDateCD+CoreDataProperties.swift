//
//  EventDateCD+CoreDataProperties.swift
//  SimplyWorkout
//
//  Created by Soyoung Hyun on 2020/09/01.
//  Copyright © 2020 soyoung hyun. All rights reserved.
//
//

import Foundation
import CoreData


extension EventDateCD {

    @nonobjc public class func createFetchRequest() -> NSFetchRequest<EventDateCD> {
        return NSFetchRequest<EventDateCD>(entityName: "EventDateCD")
    }

    @NSManaged public var activityDate: String?
    @NSManaged public var toWorkoutData: NSSet?

}

// MARK: Generated accessors for toWorkoutData
extension EventDateCD {

    @objc(addToWorkoutDataObject:)
    @NSManaged public func addToToWorkoutData(_ value: WorkoutDataCD)

    @objc(removeToWorkoutDataObject:)
    @NSManaged public func removeFromToWorkoutData(_ value: WorkoutDataCD)

    @objc(addToWorkoutData:)
    @NSManaged public func addToToWorkoutData(_ values: NSSet)

    @objc(removeToWorkoutData:)
    @NSManaged public func removeFromToWorkoutData(_ values: NSSet)

}
