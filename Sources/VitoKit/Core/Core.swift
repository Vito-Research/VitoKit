//
//  File.swift
//  
//
//  Created by Andreas Ink on 6/11/22.
//

import Foundation
import HealthKit

public class Vito: VitoPermissions {
    
    public let health = Health()
    
   
    
    public func dailyData(for category: HealthType, with startDate: Date, to endDate: Date, filterToActivity: ActivityType = .none) async -> [HealthData] {
        
//        if authorize(selectedTypes: category) {
//
//            let quanities = category == .Vitals ? HKQuantityTypeIdentifier.vitals : category == .Activity ? HKQuantityTypeIdentifier.activity : HKQuantityTypeIdentifier.mobility
//
//            let units = category == .Vitals ? HKQuantityTypeIdentifier.vitals : category == .Activity ? HKQuantityTypeIdentifier.activity : HKQuantityTypeIdentifier.mobility
//
//            for (type, unit) in Array(zip(quanities, units)) {
//            health.loadNewDataFromHealthKit(type: type, unit: unit, start: startDate, end: endDate)
//        }
//    }
        return []
    }
}
