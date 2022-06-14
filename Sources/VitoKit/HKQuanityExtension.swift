//
//  File.swift
//  
//
//  Created by Andreas Ink on 6/11/22.
//

import Foundation
import HealthKit

extension HKQuantityTypeIdentifier: CaseIterable {
    
    public static var allCases: [HKQuantityTypeIdentifier] {
        return []
    }
    
//    public static var Mobility: Set<HKQuantityTypeIdentifier> {
//        return [.walkingSpeed, .walkingStepLength, .walkingAsymmetryPercentage, appleWalkingSteadiness]
//    }
//
//    public static var Activity: Set<HKQuantityTypeIdentifier> {
//        return [.stepCount, .appleExerciseTime, .distanceCycling, .distanceSwimming, .distanceWalkingRunning, .sixMinuteWalkTestDistance]
//    }
    
    // When requesting an HKQuantityTypeIdentifier, an Outlier data struct is filled for easier handling
    public static var Vitals: Set<Outlier> {
        return [Outlier(yellowThreshold: 3, redThreshold: 4), Outlier(yellowThreshold: 0.5, redThreshold: 1, type: .respiratoryRate), Outlier(yellowThreshold: 4, redThreshold: 5, type: .restingHeartRate), Outlier(yellowThreshold: 3, redThreshold: 4, type: .walkingHeartRateAverage)]
    }
    
}
// Outlier data contains the threshold that the state machine operates on
public struct Outlier: Hashable {
    public var yellowThreshold: Float = 3
    public var redThreshold: Float = 4
    public var type: HKQuantityTypeIdentifier = .heartRate
}

extension CaseIterable where Self: RawRepresentable {
    
    static var allValues: [RawValue] {
            return allCases.map { $0.rawValue }
        }
}

// Stores HKUnits for health categories
extension HKUnit: CaseIterable {
    
    public static var allCases: [HKUnit] {
        return []
    }
    
    public static var Mobility: [HKUnit] {
        [.mile().unitDivided(by: .hour()), .inch(), .percent(), .percent()]
    }
    
    public static var Activity: [HKUnit] {
        [.count(), .hour(), .mile(), .mile(), .mile(), .mile(), .mile()]
    }
    
    public static var Vitals: [HKUnit] {
        [HKUnit(from: "count/min"), HKUnit(from: "count/min"), HKUnit(from: "count/min")]
    }
}
