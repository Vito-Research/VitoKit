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
    
    public static var mobility: [HKQuantityTypeIdentifier] {
        return [.walkingSpeed, .walkingStepLength, .walkingAsymmetryPercentage, appleWalkingSteadiness]
    }
    public static var activity: [HKQuantityTypeIdentifier] {
        return [.stepCount, .appleExerciseTime, .distanceCycling, .distanceSwimming, .distanceWalkingRunning, .sixMinuteWalkTestDistance]
    }

    public static var vitals: [HKQuantityTypeIdentifier] {
        return [.heartRate, .heartRateVariabilitySDNN, .respiratoryRate, .restingHeartRate, .oxygenSaturation]
    }
    
}
extension CaseIterable where Self: RawRepresentable {
    
    static var allValues: [RawValue] {
            return allCases.map { $0.rawValue }
        }
}


extension HKUnit: CaseIterable {
    
    public static var allCases: [HKUnit] {
        return []
    }
    
    public static var mobility: [HKUnit] {
        [.mile().unitDivided(by: .hour()), .inch(), .percent(), .percent()]
    }
    
    public static var activity: [HKUnit] {
        [.count(), .hour(), .mile(), .mile(), .mile(), .mile(), .mile()]
    }
    
    public static var vitals: [HKUnit] {
        [.count().unitDivided(by: .minute()), .secondUnit(with: .milli), .count().unitDivided(by: .minute()), .count().unitDivided(by: .minute()), .percent()]
    }
}