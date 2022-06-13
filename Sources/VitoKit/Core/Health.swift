//
//  File.swift
//  
//
//  Created by Andreas Ink on 6/11/22.
//

import Foundation
import HealthKit
import Accelerate



public actor Health {
    public let store = HKHealthStore()
    public let anchorKey = "anchorKey"
    public var anchor: HKQueryAnchor? {
        get {
            // If user defaults returns nil, just return it.
            guard let data = UserDefaults.standard.object(forKey: anchorKey) as? Data else {
                return nil
            }

            // Otherwise, unarchive and return the data object.
            do {
                return try NSKeyedUnarchiver.unarchivedObject(ofClass: HKQueryAnchor.self, from: data)
            } catch {
                // If an error occurs while unarchiving, log the error and return nil.
               // logger.error("Unable to unarchive \(data): \(error.localizedDescription)")
                return nil
            }
        }
        set(newAnchor) {
            // If the new value is nil, save it.
            guard let newAnchor = newAnchor else {
                UserDefaults.standard.set(nil, forKey: anchorKey)
                return
            }

            // Otherwise convert the anchor object to Data, and save it in user defaults.
            do {
                let data = try NSKeyedArchiver.archivedData(withRootObject: newAnchor, requiringSecureCoding: true)
                UserDefaults.standard.set(data, forKey: anchorKey)
            } catch {
                // If an error occurs while archiving the anchor, just log the error.
                // the value stored in user defaults is not changed.
              //  logger.error("Unable to archive \(newAnchor): \(error.localizedDescription)")
            }
        }
    }
    @discardableResult
    public func loadNewDataFromHealthKit(type: HKSampleType, unit: HKUnit, start: Date, end: Date, activityType: ActivityType) async throws -> HealthData? {
        
        let (samples, _, newAnchor) = try await queryHealthKit(type, startDate: start, endDate: end)
            // Update the anchor.
        self.anchor = newAnchor
        if let quantitySamples = samples?.compactMap({ sample in
            sample as? HKQuantitySample
        }).map({$0.quantity.doubleValue(for: unit)}) {
            //.filter{$0.metadata?["HKMetadataKeyHeartRateMotionContext"] as? NSNumber == activityType.rawValue }
            return HealthData(id: UUID().uuidString, type: .Health, title: type.identifier, text: "", date: start, endDate: end, data: vDSP.mean(quantitySamples), risk: 0)
            } else {
                return nil
            }
           
        
    }
    public func queryHealthKit(_ type: HKSampleType, startDate: Date, endDate: Date) async throws -> ([HKSample]?, [HKDeletedObject]?, HKQueryAnchor?) {
        return try await withCheckedThrowingContinuation { continuation in
            // Create a predicate that only returns samples created within the last 24 hours.
          
            let datePredicate = HKQuery.predicateForSamples(withStart: startDate, end: endDate, options: [.strictStartDate, .strictEndDate])
            
            // Create the query.
            let query = HKAnchoredObjectQuery(
                type: type,
                predicate: datePredicate,
                anchor: nil,
                limit: HKObjectQueryNoLimit) { (_, samples, deletedSamples, newAnchor, error) in
                //print(samples)
                // When the query ends, check for errors.
                if let error = error {
                    continuation.resume(throwing: error)
                } else {
                    //print(samples)
                    continuation.resume(returning: (samples, deletedSamples, newAnchor))
                }
                
            }
            store.execute(query)
        }
    }
}
