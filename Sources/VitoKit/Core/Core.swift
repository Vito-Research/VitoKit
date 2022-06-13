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
    
    
    public func dailyData(for category: HealthType, with startDate: Date, to endDate: Date, filterToActivity: ActivityType = .none) {
        let health = Health()
        Task {
            var stateMachine = StateMachine()
            for day in Date.dates(from: startDate, to: endDate) {
                if let sleep = try await health.queryHealthKit(HKObjectType.categoryType(forIdentifier: HKCategoryTypeIdentifier.sleepAnalysis)!, startDate: day, endDate: day.addingTimeInterval(.day * -1.0)).0 {
                    if let start = sleep.map({$0.startDate}).min() {
                        if let end = sleep.map({$0.endDate}).max() {
                            let diffComponents = Calendar.current.dateComponents([.hour], from: start, to: end)
                           
                    for (type, unit) in Array(zip(HKQuantityTypeIdentifier.vitals, HKUnit.vitals)) {
                        do {

                            if let data = try await health.queryHealthKit(HKQuantityType(type), startDate: start, endDate: end).0 {

                                let dataAsSample = data.compactMap({ sample in
                                    sample as? HKQuantitySample
                                }).filter{filterToActivity == .none ? true : $0.metadata?["HKMetadataKeyHeartRateMotionContext"] as? NSNumber != filterToActivity.rawValue && $0.startDate.getTimeOfDay() == "Night"}
                                 let avg = vDSP.mean(dataAsSample.map({ $0.quantity.doubleValue(for: unit)}) )
                                    
                                if avg.isNormal {
                                    let risk = Int(stateMachine.calculateMedian(Int(avg), day, yellowThres: 3, redThres: 4))
                                    self.healthData.append(HealthData(id: UUID().uuidString, type: .Health, title: "", text: "", date: day, endDate: day.addingTimeInterval(.day * -1), data: avg, risk: stateMachine.returnNumberOfAlerts() > 10 ? risk : 0))
                                } else if let val = dataAsSample.first?.quantity.doubleValue(for: unit) {
                                    let risk = Int(stateMachine.calculateMedian(Int(val), day, yellowThres: 3, redThres: 4))
                                    self.healthData.append(HealthData(id: UUID().uuidString, type: .Health, title: "", text: "", date: day, endDate: day.addingTimeInterval(.day * -1), data: val, risk: stateMachine.returnNumberOfAlerts() > 10 ? risk : 0))
                                } else {
                                    stateMachine.resetAlert()
//                                    if let data = try await health.queryHealthKit(HKQuantityType(type), startDate: start.addingTimeInterval(.day), endDate: start.addingTimeInterval(-.day * 2)).0 {
//                                        let dataAsSample = data.compactMap({ sample in
//                                            sample as? HKQuantitySample
//                                         })
//
//                                        let val = vDSP.mean(dataAsSample.map({ $0.quantity.doubleValue(for: unit)}))
//                                        if val.isNormal {
//                                    let risk = Int(stateMachine.calculateMedian(Int(val), day, yellowThres: 3, redThres: 4))
//                                            self.healthData.append(HealthData(id: UUID().uuidString, type: .Health, title: "", text: "", date: day, endDate: day.addingTimeInterval(.day * -1), data: val, risk: stateMachine.returnNumberOfAlerts() > 10 ? risk : 0))
//                                        } else {
//                                            stateMachine.resetAlert()
//                                        }
//                            }
                                }
                            }
                        } catch {
print(error)
                        }
                        }
                    //}

                }
                }
                }
        }
        }
     
    }
}
