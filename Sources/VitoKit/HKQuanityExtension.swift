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
    public static var Mobility: Set<Outlier> {
        return [Outlier(yellowThreshold: 0, redThreshold: 0, type: .walkingSpeed, unit: .mile().unitDivided(by: .hour())), Outlier(yellowThreshold: 0, redThreshold: 0, type: .walkingStepLength, unit: .inch()), Outlier(yellowThreshold: 0, redThreshold: 0, type: .walkingAsymmetryPercentage, unit: .percent()),
                Outlier(yellowThreshold: 3, redThreshold: 4, type: .walkingDoubleSupportPercentage, unit: .percent())]
    }
    public static var Activity: Set<Outlier> {
        return [Outlier(yellowThreshold: 0, redThreshold: 0, type: .stepCount, unit: .count())]
    }
    // When requesting an HKQuantityTypeIdentifier, an Outlier data struct is filled for easier handling
    public static var Vitals: Set<Outlier> {
        return [Outlier(),
                Outlier(yellowThreshold: 4, redThreshold: 5, type: .oxygenSaturation, unit: HKUnit(from: "count/min")),
                Outlier(yellowThreshold: -10, redThreshold: -15, type: .heartRateVariabilitySDNN, unit: HKUnit(from: "count/min")),
                Outlier(yellowThreshold: 2, redThreshold: 3, type: .respiratoryRate, unit: HKUnit(from: "count/min"))]
    }
    
}
// Outlier data contains the threshold that the state machine operates on
public struct Outlier: Hashable {
    public var yellowThreshold: Float
    public var redThreshold: Float
    public var type: HKQuantityTypeIdentifier
    public var unit: HKUnit
    public init(yellowThreshold: Float = 3, redThreshold: Float = 4, type: HKQuantityTypeIdentifier = .heartRate, unit: HKUnit = .count().unitDivided(by: .minute())) {
        self.yellowThreshold = yellowThreshold
        self.redThreshold = redThreshold
        self.type = type
        self.unit = unit
    }
}

extension CaseIterable where Self: RawRepresentable {
    
    static var allValues: [RawValue] {
            return allCases.map { $0.rawValue }
        }
}

