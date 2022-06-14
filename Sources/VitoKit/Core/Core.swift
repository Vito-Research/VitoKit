//
//  File.swift
//  
//
//  Created by Andreas Ink on 6/11/22.
//

import Foundation
import HealthKit
import SwiftUI
import Accelerate

@MainActor
public class Vito: VitoPermissions {
    
     
    

    @Published public var healthData = [HealthData]()
    
    
    public func vitoState(for category: HealthType, with startDate: Date, to endDate: Date, filterToActivity: ActivityType = .none, yellowThreshold: Float, redThreshold: Float) {
        let health = Health()
        Task {
            var stateMachine = StateMachine()
            for day in Date.dates(from: startDate, to: endDate) {
                if let sleep = try await health.queryHealthKit(HKObjectType.categoryType(forIdentifier: HKCategoryTypeIdentifier.sleepAnalysis)!, startDate: day, endDate: day.addingTimeInterval(.day * -1.0)).0 {
                    if let start = sleep.map({$0.startDate}).min() {
                        if let end = sleep.map({$0.endDate}).max() {
                            
                    for (type, unit) in Array(zip(HKQuantityTypeIdentifier.Vitals, HKUnit.Vitals)) {
                        do {

                            if let data = try await health.queryHealthKit(HKQuantityType(type), startDate: start, endDate: end).0 {

                                let dataAsSample = data.compactMap({ sample in
                                    sample as? HKQuantitySample
                                }).filter{filterToActivity == .none ? true : $0.metadata?["HKMetadataKeyHeartRateMotionContext"] as? NSNumber != filterToActivity.rawValue && $0.startDate.getTimeOfDay() == "Night"}
                                 let avg = vDSP.mean(dataAsSample.map({ $0.quantity.doubleValue(for: unit)}) )
                                    
                                if avg.isNormal {
                                    let risk = Int(stateMachine.calculateMedian(Int(avg), day, yellowThres: yellowThreshold, redThres: redThreshold))
                                    self.healthData.append(HealthData(id: UUID().uuidString, type: .Health, title: "", text: "", date: day, endDate: day.addingTimeInterval(.day * -1), data: avg, risk: stateMachine.returnNumberOfAlerts() > 10 ? risk : 0))
                                } else if let val = dataAsSample.first?.quantity.doubleValue(for: unit) {
                                    let risk = Int(stateMachine.calculateMedian(Int(val), day, yellowThres: yellowThreshold, redThres: redThreshold))
                                    self.healthData.append(HealthData(id: UUID().uuidString, type: .Health, title: "", text: "", date: day, endDate: day.addingTimeInterval(.day * -1), data: val, risk: stateMachine.returnNumberOfAlerts() > 10 ? risk : 0))
                                } else {
                                    stateMachine.resetAlert()

                                }
                            }
                        } catch {
                                print(error)
                        }
                        }
           

                }
                }
                }
        }
        }
     
    }
    public func outliers(for category: HealthType, with startDate: Date, to endDate: Date, filterToActivity: ActivityType = .none, yellowThreshold: Float, redThreshold: Float) {
        let health = Health()
        Task {
            var stateMachine = StateMachine()
            for day in Date.dates(from: startDate, to: endDate) {
               
                           
                    for (type, unit) in Array(zip(HKQuantityTypeIdentifier.Vitals, HKUnit.Vitals)) {
                        do {

                            if let data = try await health.queryHealthKit(HKQuantityType(type), startDate: day.addingTimeInterval(.day), endDate: day).0 {

                                let dataAsSample = data.compactMap({ sample in
                                    sample as? HKQuantitySample
                                })
                                 let avg = vDSP.mean(dataAsSample.map({ $0.quantity.doubleValue(for: unit)}) )
                                    
                                if avg.isNormal {
                                    let risk = Int(stateMachine.calculateMedian(Int(avg), day, yellowThres: yellowThreshold, redThres: redThreshold))
                                    self.healthData.append(HealthData(id: UUID().uuidString, type: .Health, title: "", text: "", date: day, endDate: day.addingTimeInterval(.day * -1), data: avg, risk: stateMachine.returnNumberOfAlerts() > 10 ? risk : 0))
                                } else if let val = dataAsSample.first?.quantity.doubleValue(for: unit) {
                                    let risk = Int(stateMachine.calculateMedian(Int(val), day, yellowThres: yellowThreshold, redThres: redThreshold))
                                    self.healthData.append(HealthData(id: UUID().uuidString, type: .Health, title: "", text: "", date: day, endDate: day.addingTimeInterval(.day * -1), data: val, risk: stateMachine.returnNumberOfAlerts() > 10 ? risk : 0))
                                } else {
                                    stateMachine.resetAlert()

                                }
                            }
                        } catch {
                                print(error)
                        }
                        }
                }
                }
                }
}
