//
//  File.swift
//
//
//  Created by Andreas Ink on 6/11/22.
//

import Foundation
import HealthKit
import SwiftUI

public class VitoPermissions: Fitbit {
    public func checkForAuth(_ selectedTypes: [HealthType]) -> Bool {
        let quanityTypes: Set<HKObjectType> = getAllTypes(selectedTypes: selectedTypes)

        return quanityTypes.map { HKHealthStore().authorizationStatus(for: .quantityType(forIdentifier: HKQuantityTypeIdentifier(rawValue: $0.identifier)) ?? .workoutType()) == .notDetermined }.filter { $0 == true }.count > 0
    }

    @AppStorage("fitbit") public var fitbit = false
    @AppStorage("launchedBefore") public var launchedBefore = false
    public init(selectedTypes: [HealthType], fitbit: Bool = true) {
        var quanityTypes: Set<HKObjectType> = []
        for type in selectedTypes {
            switch type {
            case .Vitals:
                let vitals = HKQuantityTypeIdentifier.Vitals

                quanityTypes.formUnion(Set<HKQuantityType>(vitals.map { id in
                    HKQuantityType(id.type)
                }))
            case .Mobility:
                let mobility = HKQuantityTypeIdentifier.Mobility

                quanityTypes.formUnion(Set<HKQuantityType>(mobility.map { id in
                    HKQuantityType(id.type)
                }))
            case .Activity:
                let activity = HKQuantityTypeIdentifier.Activity

                quanityTypes.formUnion(Set<HKQuantityType>(activity.map { id in
                    HKQuantityType(id.type)
                }))
            }
        }
        print(quanityTypes)

        self.fitbit = fitbit
        autheticated = false
    }

    func start(selectedTypes: [HealthType], fitbit: Bool = true) {
        if fitbit {
            if !UserDefaults().bool(forKey: "launchedBefore") {
                autheticated = true
            } else {
                autheticated = false
            }
        } else {
            var quanityTypes: Set<HKObjectType> = []
            for type in selectedTypes {
                switch type {
                case .Vitals:
                    let vitals = HKQuantityTypeIdentifier.Vitals

                    quanityTypes.formUnion(Set<HKQuantityType>(vitals.map { id in
                        HKQuantityType(id.type)
                    }))
                case .Mobility:
                    let mobility = HKQuantityTypeIdentifier.Mobility

                    quanityTypes.formUnion(Set<HKQuantityType>(mobility.map { id in
                        HKQuantityType(id.type)
                    }))
                case .Activity:
                    let activity = HKQuantityTypeIdentifier.Activity

                    quanityTypes.formUnion(Set<HKQuantityType>(activity.map { id in
                        HKQuantityType(id.type)
                    }))
                }
            }
            print(quanityTypes)
            if fitbit {
                if !UserDefaults().bool(forKey: "launchedBefore") {
                    autheticated = true
                } else {
                    autheticated = false
                }
            } else {
                autheticated = quanityTypes.map { HKHealthStore().authorizationStatus(for: .quantityType(forIdentifier: HKQuantityTypeIdentifier(rawValue: $0.identifier)) ?? .workoutType()) == .notDetermined }.filter { $0 == true }.count > 0
            }
        }
        self.fitbit = fitbit
    }

    // Core class for HK
    public let healthStore = HKHealthStore()

    // Health category types
    public var selectedTypes: [HealthType] = [.Vitals]

    // true if permissions are granted
    @Published public var autheticated: Bool

    public func auth(selectedTypes: [HealthType]) {
        Task {
            do {
                try await authorize(selectedTypes: selectedTypes)

                self.autheticated = checkForAuth(selectedTypes)

            } catch {}
        }
    }

    public func getAllTypes(selectedTypes: [HealthType]) -> Set<HKObjectType> {
        var quanityTypes: Set<HKObjectType> = []
        for type in selectedTypes {
            print(type)
            switch type {
            case .Vitals:
                let vitals = HKQuantityTypeIdentifier.Vitals

                quanityTypes.formUnion(Set<HKQuantityType>(vitals.map { id in
                    HKQuantityType(id.type)
                }))
            case .Mobility:
                let mobility = HKQuantityTypeIdentifier.Mobility

                quanityTypes.formUnion(Set<HKQuantityType>(mobility.map { id in
                    HKQuantityType(id.type)
                }))
            case .Activity:
                let activity = HKQuantityTypeIdentifier.Activity

                quanityTypes.formUnion(Set<HKQuantityType>(activity.map { id in
                    HKQuantityType(id.type)
                }))
            }
        }
        return quanityTypes
    }

    // Authorizes request for health data
    public func authorize(selectedTypes: [HealthType], addSleep: Bool = false) async throws {
        var quanityTypes = getAllTypes(selectedTypes: selectedTypes)

        // loops to append HKQuantityTypes from various health categories

        if addSleep {
            quanityTypes.formUnion([HKObjectType.categoryType(forIdentifier: .sleepAnalysis)!])
        }
        try await healthStore.requestAuthorization(toShare: [], read: quanityTypes)
        try await healthStore.requestAuthorization(toShare: [], read: [HKObjectType.categoryType(forIdentifier: .sleepAnalysis)!])
    }
}
