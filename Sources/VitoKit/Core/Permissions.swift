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
        self.auth()
    }
    
    public let healthStore = HKHealthStore()
    
    public var selectedTypes: [HealthType] = [.Activity]
    
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
    
    public func authorize(selectedTypes: [HealthType] = []) async throws {
        var selected = [HealthType]()
        var quanityTypes: Set<HKQuantityType> = []
        
        selected = selectedTypes.isEmpty ? self.selectedTypes : selectedTypes
            
        
        for type in selected {
            switch(type) {
            case .Activity:
                
                let activity = HKQuantityTypeIdentifier.Activity
                
                quanityTypes.formUnion( Set<HKQuantityType>(activity.map { id in
                    return HKQuantityType(id)
                }))
            
            case .Mobility:
                let mobility = HKQuantityTypeIdentifier.Mobility
                
                quanityTypes.formUnion( Set<HKQuantityType>(mobility.map { id in
                    return HKQuantityType(id)
                }))
            case .Vitals:
                let vitals = HKQuantityTypeIdentifier.Vitals
                
                quanityTypes.formUnion( Set<HKQuantityType>(vitals.map { id in
                    return HKQuantityType(id)
                }))
            }
            
        }
        let vitals = HKQuantityTypeIdentifier.Vitals
        
        quanityTypes =  Set<HKQuantityType>(vitals.map { id in
            return HKQuantityType(id)
        })
        try await self.healthStore.requestAuthorization(toShare: [], read: quanityTypes)
        try await self.healthStore.requestAuthorization(toShare: [], read: [HKObjectType.categoryType(forIdentifier: .sleepAnalysis)!])
        
    }
}
