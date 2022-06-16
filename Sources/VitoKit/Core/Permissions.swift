//
//  File.swift
//  
//
//  Created by Andreas Ink on 6/11/22.
//

import Foundation
import HealthKit
import SwiftUI


@MainActor
public class VitoPermissions: ObservableObject {
    
    public init() {
        // on initalization, check for data authetication (ensure we have permissions to use data)
        self.auth()
    }
    
    // Core class for HK
    public let healthStore = HKHealthStore()
    
    // Health category types
    public var selectedTypes: [HealthType] = [.Vitals]
    
    // true if permissions are granted
    @Published public var autheticated = false
    
    public func auth() {
        
        Task {
            do {
                
                try await authorize()
                withAnimation(.easeInOut) {
                    autheticated = true
                }
               
            } catch {
                
            }
            
        }
        
        
    }
    // Authorizes request for health data
    public func authorize(selectedTypes: [HealthType] = [], addSleep: Bool = true) async throws {
        var selected = [HealthType]()
        var quanityTypes: Set<HKObjectType> = []
        
        selected = selectedTypes.isEmpty ? self.selectedTypes : selectedTypes
            
        // loops to append HKQuantityTypes from various health categories
        for type in selected {
            switch(type) {

            case .Vitals:
                let vitals = HKQuantityTypeIdentifier.Vitals
                
                quanityTypes.formUnion( Set<HKQuantityType>(vitals.map { id in
                    return HKQuantityType(id.type)
                }))
            case .Mobility:
                let mobility = HKQuantityTypeIdentifier.Mobility
                
                quanityTypes.formUnion( Set<HKQuantityType>(mobility.map { id in
                    return HKQuantityType(id.type)
                }))
            case .Activity:
                let activity = HKQuantityTypeIdentifier.Activity
                
                quanityTypes.formUnion( Set<HKQuantityType>(activity.map { id in
                    return HKQuantityType(id.type)
                }))
            }
            
        }
    
        if addSleep {
            quanityTypes.formUnion([HKObjectType.categoryType(forIdentifier: .sleepAnalysis)!])
        }
        try await self.healthStore.requestAuthorization(toShare: [], read: quanityTypes)
        try await self.healthStore.requestAuthorization(toShare: [], read: [HKObjectType.categoryType(forIdentifier: .sleepAnalysis)!])
        
    }
}
