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
    
    // If 1 then data has loaded
    @Published public var progress: CGFloat = 0.0
    
    // Contextualizes the last current day's outlier
    @Published public var risk = Risk(id: UUID().uuidString, risk: 21, explanation: [Explanation(image: .return, explanation: "Loading", detail: "")])
    
    // Special state machine for heart rate data, filters to when asleep, inactive, and at night
    /// To be reimplmented
    
    // Detects outliers within the data
    public func outliers(for category: Outlier, unit: HKUnit, with startDate: Date, to endDate: Date, filterToActivity: ActivityType = .none, context: String = "") {
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
                                   
                                      
                                    self.healthData.append(HealthData(id: UUID().uuidString, type: .Health, title: category.type.rawValue, text: "", date: day, endDate: day.addingTimeInterval(.day * -1), data: avg, risk: stateMachine.returnNumberOfAlerts() > 10 ? risk : 0, dataPoints: dataAsSample.map{HealthDataPoint(date: $0.startDate, value: $0.quantity.doubleValue(for: unit))}, context: context))
                                        
                              
                                } else if let val = dataAsSample.first?.quantity.doubleValue(for: unit) {
                                    let risk = Int(stateMachine.calculateMedian(Int(val), day, yellowThres: category.yellowThreshold, redThres: category.redThreshold))
                                 
                                      
                                        self.healthData.append(HealthData(id: UUID().uuidString, type: .Health, title: category.type.rawValue, text: "", date: day, endDate: day.addingTimeInterval(.day * -1), data: avg, risk: stateMachine.returnNumberOfAlerts() > 10 ? risk : 0, dataPoints: dataAsSample.map{HealthDataPoint(date: $0.startDate, value: $0.quantity.doubleValue(for: unit))},  context: context))
                                        
                      
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

                }
                }
                }
                }
   // Calculates average
   public func average(numbers: [Double]) -> Double {
        // Speedier computation
        return vDSP.mean(numbers)
    }
}
