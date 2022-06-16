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

// Core class that inherits VitoPermissions and contains core functions

// Main actor keeps all operations on main thread (avoids purple warning)
@MainActor
public class Vito: VitoPermissions {
    
     
    
    // Stores health data for reference or computations
    @Published public var healthData = [HealthData]()
    
    @Published public var progress: CGFloat = 0.0
    
    @Published public var risk = Risk(id: UUID().uuidString, risk: 21, explanation: [Explanation(image: .return, explanation: "Loading", detail: "")])
    
    // Special state machine for heart rate data, filters to when asleep, inactive, and at night
    public func vitoState(for category: HealthType, with startDate: Date, to endDate: Date, filterToActivity: ActivityType = .none) {
        let health = Health()
        Task {
            var stateMachine = StateMachine()
            let dates = Date.dates(from: startDate, to: endDate)
            for (day, i) in Array(zip(dates, dates.indices)) {
                if let sleep = try await health.queryHealthKit(HKObjectType.categoryType(forIdentifier: HKCategoryTypeIdentifier.sleepAnalysis)!, startDate: day, endDate: day.addingTimeInterval(.day * -1.0)).0 {
                    if let start = sleep.map({$0.startDate}).min() {
                        if let end = sleep.map({$0.endDate}).max() {
                            
                    for (type, unit) in Array(zip(HKQuantityTypeIdentifier.Mobility, HKUnit.Mobility)) {
                        do {

                            if let data = try await health.queryHealthKit(HKQuantityType(type.type), startDate: start, endDate: end).0 {

                                let dataAsSample = data.compactMap({ sample in
                                    sample as? HKQuantitySample
                                })//.filter{filterToActivity == .none ? true : $0.metadata?["HKMetadataKeyHeartRateMotionContext"] as? NSNumber != filterToActivity.rawValue && $0.startDate.getTimeOfDay() == "Night"}
                                 let avg = vDSP.mean(dataAsSample.map({ $0.quantity.doubleValue(for: unit)}) )
                                    
                                if avg.isNormal {
                                    let risk = Int(stateMachine.calculateMedian(Int(avg), day, yellowThres: type.yellowThreshold, redThres: type.redThreshold))
                                 
                                    self.healthData.append(HealthData(id: UUID().uuidString, type: .Health, title: type.type.rawValue, text: "", date: day, endDate: day.addingTimeInterval(.day * -1), data: avg, risk: stateMachine.returnNumberOfAlerts() > 10 ? risk : 0, dataPoints: dataAsSample.map{HealthDataPoint(date: $0.startDate, value: $0.quantity.doubleValue(for: unit))}))
                                   
                                } else if let val = dataAsSample.first?.quantity.doubleValue(for: unit) {
                                    let risk = Int(stateMachine.calculateMedian(Int(val), day, yellowThres: type.yellowThreshold, redThres: type.redThreshold))
                                   
                                    self.healthData.append(HealthData(id: UUID().uuidString, type: .Health, title: type.type.rawValue, text: "", date: day, endDate: day.addingTimeInterval(.day * -1), data: avg, risk: stateMachine.returnNumberOfAlerts() > 10 ? risk : 0, dataPoints: dataAsSample.map{HealthDataPoint(date: $0.startDate, value: $0.quantity.doubleValue(for: unit))}))
                                    
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
                if progress < 1 {
                    progress += (CGFloat(i) / CGFloat(dates.count))
                } else {
                    if let last = self.healthData.last {
                        withAnimation(.beat) {
                        risk = Risk(id: UUID().uuidString, risk: CGFloat(last.risk), explanation: [Explanation]())
                        }
                    }
                }
        }
        }
     
    }
    // Detects outliers within the data
    public func outliers(for category: Outlier, unit: HKUnit, with startDate: Date, to endDate: Date, filterToActivity: ActivityType = .none) {
        let health = Health()
        Task {
            var stateMachine = StateMachine()
            let dates = Date.dates(from: startDate, to: endDate)
            for (day, i) in Array(zip(dates, dates.indices)) {
               
                        do {

                            if let data = try await health.queryHealthKit(HKQuantityType(category.type), startDate: day.addingTimeInterval(.day), endDate: day).0 {

                                let dataAsSample = data.compactMap({ sample in
                                    sample as? HKQuantitySample
                                })
                                let avg = vDSP.mean(dataAsSample.map({ $0.quantity.doubleValue(for: category.unit)}) )
                                    
                                if avg.isNormal {
                                    let risk = Int(stateMachine.calculateMedian(Int(avg), day, yellowThres: category.yellowThreshold, redThres: category.redThreshold))
                                    //if let toDay = day.asDay() {
                                      
                                        self.healthData.append(HealthData(id: UUID().uuidString, type: .Health, title: category.type.rawValue, text: "", date: day, endDate: day.addingTimeInterval(.day * -1), data: avg, risk: stateMachine.returnNumberOfAlerts() > 10 ? risk : 0, dataPoints: dataAsSample.map{HealthDataPoint(date: $0.startDate, value: $0.quantity.doubleValue(for: unit))}))
                                        
                                   // }
                                } else if let val = dataAsSample.first?.quantity.doubleValue(for: unit) {
                                    let risk = Int(stateMachine.calculateMedian(Int(val), day, yellowThres: category.yellowThreshold, redThres: category.redThreshold))
                                   // if let toDay = day.asDay() {
                                      
                                        self.healthData.append(HealthData(id: UUID().uuidString, type: .Health, title: category.type.rawValue, text: "", date: day, endDate: day.addingTimeInterval(.day * -1), data: avg, risk: stateMachine.returnNumberOfAlerts() > 10 ? risk : 0, dataPoints: dataAsSample.map{HealthDataPoint(date: $0.startDate, value: $0.quantity.doubleValue(for: unit))}))
                                        
                                    //}
                                } else {
                                    stateMachine.resetAlert()

                                }
                            }
                        } catch {
                                print(error)
                        }

                if progress < 1 {
                    withAnimation(.linear) {
                    progress += (CGFloat(i) / CGFloat(dates.count))
                    }
                } else {
//                    if let last = self.healthData.last {
//                        risk = Risk(id: UUID().uuidString, risk: CGFloat(last.risk), explanation: [Explanation]())
//                    }
                }
                }
                }
                }
   public func average(numbers: [Double]) -> Double {
        // print(numbers)
        return vDSP.mean(numbers)
    }
}
