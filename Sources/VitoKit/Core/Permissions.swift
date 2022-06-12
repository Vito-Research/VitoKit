//
//  File.swift
//  
//
//  Created by Andreas Ink on 6/11/22.
//

import Foundation
import HealthKit

public class VitoPermissions {
    
    public init() {}
    
    public let healthStore = HKHealthStore()
    
    public var selectedTypes: [HealthType] = [.Vitals]
    
    public func authorize(selectedTypes: [HealthType] = []) async throws {
        var selected = [HealthType]()
        var quanityTypes: Set<HKQuantityType> = []
        
        selected = selectedTypes.isEmpty ? self.selectedTypes : selectedTypes
            
        
        for type in selected {
            switch(type) {
            case .Activity:
                
                let activity = HKQuantityTypeIdentifier.activity
                
                quanityTypes =  Set<HKQuantityType>(activity.map { id in
                    return HKQuantityType(id)
                })
            
            case .Mobility:
                let mobility = HKQuantityTypeIdentifier.mobility
                
                quanityTypes =  Set<HKQuantityType>(mobility.map { id in
                    return HKQuantityType(id)
                })
            case .Vitals:
                let vitals = HKQuantityTypeIdentifier.vitals
                
                quanityTypes =  Set<HKQuantityType>(vitals.map { id in
                    return HKQuantityType(id)
                })
            }
            
        }
      
         try await self.healthStore.requestAuthorization(toShare: [], read: quanityTypes)
    }
}
