//
//  File.swift
//
//
//  Created by Andreas Ink on 6/11/22.
//

import Accelerate
import Foundation
import HealthKit
import SwiftUI

// Core class that inherits VitoPermissions and contains core functions
@MainActor
public class Vito: VitoPermissions {
        // Stores health data for reference or computations
        @UserDefault("healthData", defaultValue: []) public var healthData: [HealthData]

        @UserDefault("healthDataDict", defaultValue: [:]) public var healthDataDict:
                [Date: [HealthData]]
        //@Published public var healthDataDict: [Date: [HealthData]] = [:]
        @UserDefault("settings", defaultValue: SettingsData()) public var settings: SettingsData

        // If 1 then data has loaded
        @Published public var progress: CGFloat = 0.0

        // Contextualizes the last current day's outlier
        @Published public var risk = Risk(
                id: UUID().uuidString, risk: 21,
                explanation: [Explanation(image: .return, explanation: "Loading", detail: "")])

        // Special state machine for heart rate data, filters to when asleep, inactive, and at night
        /// To be reimplmented
        @Published var store = HKHealthStore()
        // Detects outliers within the data

        public func populateDict(_ start: Date, _ end: Date) {

                healthDataDict = [:]
                healthDataDict = healthData.sliced(by: [.day, .month, .year], for: \.date)

        }
        public func resetAnchor() {
                UserDefaults.standard.set(Data(), forKey: "anchorKey")
        }
        public func outliers(
                for category: Outlier, unit: HKUnit, with startDate: Date, to endDate: Date,
                filterToActivity: ActivityType = .none, context: String = "",
                testData: [HealthData] = []
        ) async -> Bool {

                let health = Health(store)

                do {
                        try await store.enableBackgroundDelivery(
                                for: HKQuantityType(.heartRate), frequency: .immediate)
                } catch {

                }

                print("YOOOO")

                var context = context
                if !testData.isEmpty {
                        context = "TEST"
                }
                var stateMachine = StateMachine()
                let dates = Date.dates(from: startDate, to: endDate)
                if fitbit {
                        
                } else {
                }
                for (day, i) in Array(zip(dates, dates.indices)) {
                        do {
                                var avg = 0.0
                                var dataAsSample = [HKQuantitySample]()
                                if testData.isEmpty {
                                        if fitbit {
                                                let formatter = DateFormatter()
                                                formatter.dateFormat = "yyyy-MM-dd"
                                                let start = formatter.string(
                                                        from: day.addingTimeInterval(.day))
                                                let end = formatter.string(from: day)
                                                print(start)
                                                let data = try await getHeartrate(
                                                        start: start, end: end)

                                                avg = average(
                                                        numbers: data.map {
                                                                $0.activitiesHeart.map {
                                                                        Double(
                                                                                $0.value
                                                                                        .restingHeartRate
                                                                                        ?? 0)
                                                                }
                                                        } ?? [])
                                                dataAsSample = [
                                                        HKQuantitySample(
                                                                type: HKQuantityType(.heartRate),
                                                                quantity: HKQuantity(
                                                                        unit: category.unit,
                                                                        doubleValue: avg),
                                                                start: day.addingTimeInterval(.day),
                                                                end: day)
                                                ]
                                        } else {
                                                if let data = try await health.queryHealthKit(
                                                        HKQuantityType(category.type),
                                                        startDate: day.addingTimeInterval(.day),
                                                        endDate: day
                                                ).0 {
                                                        dataAsSample = data.compactMap { sample in
                                                                sample as? HKQuantitySample
                                                        }  
                                                        avg = vDSP.mean(
                                                                dataAsSample.map {
                                                                        $0.quantity.doubleValue(
                                                                                for: category.unit)
                                                                })
                                                }
                                        }
                                } else {
                                        let data = testData.filter {
                                                $0.date.formatted(date: .numeric, time: .omitted)
                                                        == day.formatted(
                                                                date: .numeric, time: .omitted)
                                        }
                                        for data in data {
                                                dataAsSample.append(
                                                        HKQuantitySample(
                                                                type: HKQuantityType(.heartRate),
                                                                quantity: HKQuantity(
                                                                        unit: category.unit,
                                                                        doubleValue: data.data),
                                                                start: data.date, end: data.date))
                                        }
                                        avg = average(numbers: data.map { $0.data })
                                }

                                if avg.isNormal {
                                        let risk = 0  

                                        self.healthData.append(
                                                HealthData(
                                                        id: UUID().uuidString, type: .Health,
                                                        title: category.type.rawValue, text: "",
                                                        date: day,
                                                        endDate: day.addingTimeInterval(.day * -1),
                                                        data: avg,
                                                        risk: stateMachine.returnNumberOfAlerts()
                                                                > 10 ? risk : 0,
                                                        dataPoints: dataAsSample.map {
                                                                HealthDataPoint(
                                                                        date: $0.startDate,
                                                                        value: $0.quantity
                                                                                .doubleValue(
                                                                                        for: unit))
                                                        }, context: context))

                                } else if let val = dataAsSample.first?.quantity.doubleValue(
                                        for: unit)
                                {
                                        if val.isNormal {

                                                let risk = 0  
                                                self.healthData.append(
                                                        HealthData(
                                                                id: UUID().uuidString,
                                                                type: .Health,
                                                                title: category.type.rawValue,
                                                                text: "", date: day,
                                                                endDate: day.addingTimeInterval(
                                                                        .day * -1), data: avg,
                                                                risk:
                                                                        stateMachine
                                                                        .returnNumberOfAlerts() > 10
                                                                        ? risk : 0,
                                                                dataPoints: dataAsSample.map {
                                                                        HealthDataPoint(
                                                                                date: $0.startDate,
                                                                                value: $0.quantity
                                                                                        .doubleValue(
                                                                                                for:
                                                                                                        unit
                                                                                        ))
                                                                }, context: context))

                                        }

                                } else {
                                        stateMachine.resetAlert()
                                }

                                if healthData.last?.risk == 1 {

                                        if healthData.last?.date.formatted(
                                                date: .numeric, time: .omitted)
                                                == Date().formatted(date: .numeric, time: .omitted)
                                        {
                                                
                                                let content = UNMutableNotificationContent()
                                                content.title = "Stress Alert"
                                                content.subtitle =
                                                        "Your heart rate is abnormally high"
                                                content.sound = UNNotificationSound.default

                                                // show this notification five seconds from now
                                                let trigger = UNTimeIntervalNotificationTrigger(
                                                        timeInterval: 5, repeats: false)

                                                // choose a random identifier
                                                let request = UNNotificationRequest(
                                                        identifier: UUID().uuidString,
                                                        content: content, trigger: trigger)

                                                // add our notification request
                                                try await UNUserNotificationCenter.current().add(
                                                        request)
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
                return true
                
        }
        func getFitbitData(
                for category: Outlier, unit: HKUnit, with startDate: Date, to endDate: Date,
                filterToActivity: ActivityType = .none, context: String = "",
                testData: [HealthData] = []
        ) async throws {
                var stateMachine = StateMachine()
                let formatter = DateFormatter()
                formatter.dateFormat = "yyyy-MM-dd"
                let start = formatter.string(from: startDate)
                let end = formatter.string(from: endDate)
                print(start)
                if testData.isEmpty {
                        if category.type == .heartRate {
                                if let data = try await getHeartrate(start: start, end: end)?
                                        .activitiesHeart
                                {
                                        print(data)

                                        for day in data {
                                                if let value = day.value.restingHeartRate {
                                                        if let date = formatter.date(
                                                                from: day.dateTime)
                                                        {
                                                                let risk = Int(
                                                                        stateMachine.calculateMedian(
                                                                                Int(value), date,
                                                                                yellowThres:
                                                                                        category
                                                                                        .yellowThreshold,
                                                                                redThres: category
                                                                                        .redThreshold
                                                                        ))

                                                                self.healthData.append(
                                                                        HealthData(
                                                                                id: UUID()
                                                                                        .uuidString,
                                                                                type: .Health,
                                                                                title: category.type
                                                                                        .rawValue,
                                                                                text: "",
                                                                                date: date,
                                                                                endDate: date,
                                                                                data: Double(value),
                                                                                risk:
                                                                                        stateMachine
                                                                                        .returnNumberOfAlerts()
                                                                                        > 10
                                                                                        ? risk : 0,
                                                                                dataPoints: [
                                                                                        HealthDataPoint(
                                                                                                date:
                                                                                                        date,
                                                                                                value:
                                                                                                        Double(
                                                                                                                value
                                                                                                        )
                                                                                        )
                                                                                ], context: context)
                                                                )
                                                        }
                                                }
                                        }
                                }
                        } else if category.type == .oxygenSaturation {
                                if let data = try await getO2(start: start, end: end) {
                                        for day in data.br {
                                                let value = day.value.breathingRate
                                                if let date = formatter.date(from: day.dateTime) {
                                                        let risk = Int(
                                                                stateMachine.calculateMedian(
                                                                        Int(value), date,
                                                                        yellowThres: category
                                                                                .yellowThreshold,
                                                                        redThres: category
                                                                                .redThreshold))

                                                        self.healthData.append(
                                                                HealthData(
                                                                        id: UUID().uuidString,
                                                                        type: .Health,
                                                                        title: category.type
                                                                                .rawValue, text: "",
                                                                        date: date, endDate: date,
                                                                        data: Double(value),
                                                                        risk:
                                                                                stateMachine
                                                                                .returnNumberOfAlerts()
                                                                                > 10 ? risk : 0,
                                                                        dataPoints: [
                                                                                HealthDataPoint(
                                                                                        date: date,
                                                                                        value:
                                                                                                Double(
                                                                                                        value
                                                                                                ))
                                                                        ], context: context))
                                                }
                                        }
                                }

                        } else if category.type == .heartRateVariabilitySDNN {
                                if let data = try await getHRV(start: start, end: end) {
                                        for day in data.hrv {
                                                let value = day.value.deepRmssd
                                                if let date = formatter.date(from: day.dateTime) {
                                                        let risk = Int(
                                                                stateMachine.calculateMedian(
                                                                        Int(value), date,
                                                                        yellowThres: category
                                                                                .yellowThreshold,
                                                                        redThres: category
                                                                                .redThreshold))

                                                        self.healthData.append(
                                                                HealthData(
                                                                        id: UUID().uuidString,
                                                                        type: .Health,
                                                                        title: category.type
                                                                                .rawValue, text: "",
                                                                        date: date, endDate: date,
                                                                        data: Double(value),
                                                                        risk:
                                                                                stateMachine
                                                                                .returnNumberOfAlerts()
                                                                                > 10 ? risk : 0,
                                                                        dataPoints: [
                                                                                HealthDataPoint(
                                                                                        date: date,
                                                                                        value:
                                                                                                Double(
                                                                                                        value
                                                                                                ))
                                                                        ], context: context))
                                                }
                                        }
                                }
                        } else if category.type == .respiratoryRate {
                                if let data = try await getRR(start: start, end: end) {
                                        for day in data {
                                                let value = day.value.avg
                                                if let date = formatter.date(from: day.dateTime) {
                                                        let risk = Int(
                                                                stateMachine.calculateMedian(
                                                                        Int(value), date,
                                                                        yellowThres: category
                                                                                .yellowThreshold,
                                                                        redThres: category
                                                                                .redThreshold))

                                                        self.healthData.append(
                                                                HealthData(
                                                                        id: UUID().uuidString,
                                                                        type: .Health,
                                                                        title: category.type
                                                                                .rawValue, text: "",
                                                                        date: date, endDate: date,
                                                                        data: Double(value),
                                                                        risk:
                                                                                stateMachine
                                                                                .returnNumberOfAlerts()
                                                                                > 10 ? risk : 0,
                                                                        dataPoints: [
                                                                                HealthDataPoint(
                                                                                        date: date,
                                                                                        value:
                                                                                                Double(
                                                                                                        value
                                                                                                ))
                                                                        ], context: context))
                                                }
                                        }
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
