//
//  File.swift
//  
//
//  Created by Andreas Ink on 6/12/22.
//

import Foundation
import HealthKit

extension HKHealthStore {
    public static var type: HealthType = .Vitals
    public static var status = HKHealthStore().authorizationStatus(for: HKQuantityType(type == .Vitals ? .heartRate : .stepCount)) == .sharingAuthorized
}
