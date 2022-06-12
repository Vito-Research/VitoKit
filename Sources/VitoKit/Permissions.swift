//
//  File.swift
//  
//
//  Created by Andreas Ink on 6/11/22.
//

import Foundation
import HealthKit

public class VitoPermissions {
    
    let healthStore = HKHealthStore()
    
    var selectedTypes: [HealthType] = []
    
    public func authorize(selectedTypes: [HealthType] = selectedTypes) async -> Bool {
        
        var quanityTypes = [HKQuantityType]()
        
        for type in selectedTypes {
            switch(type) {
            case .Activity:
                quanityTypes.append(contentsOf: HKQuantityTypeIdentifier.activity)
            case .Mobility:
                quanityTypes.append(contentsOf: HKQuantityTypeIdentifier.mobility)
            case .Vitals:
                quanityTypes.append(contentsOf: HKQuantityTypeIdentifier.vitals)
            }
            
        }
      
        self.healthStore.requestAuthorization(toShare: [], read: quanityTypes)
    }
}
