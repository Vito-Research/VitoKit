//
//  File.swift
//  
//
//  Created by Andreas Ink on 6/12/22.
//

import Foundation

extension Date {
    static func dates(from fromDate: Date, to toDate: Date) -> [Date] {
        var dates: [Date] = []
        var date = fromDate
        
        while date <= toDate {
            dates.append(date)
            guard let newDate = Calendar.current.date(byAdding: .day, value: 1, to: date) else { break }
            date = newDate
        }
        return dates
    }
    static func datesHourly(from fromDate: Date, to toDate: Date) -> [Date] {
        var dates: [Date] = []
        var date = fromDate
        
        while date <= toDate {
            dates.append(date)
            guard let newDate = Calendar.current.date(byAdding: .hour, value: 1, to: date) else { break }
            date = newDate
        }
        return dates
    }
}
extension Date {
    func get(_ components: Calendar.Component..., calendar: Calendar = Calendar.current) -> DateComponents {
        return calendar.dateComponents(Set(components), from: self)
    }
    
    func get(_ component: Calendar.Component, calendar: Calendar = Calendar.current) -> Int {
        return calendar.component(component, from: self)
    }
}
extension Date {
   func getFormattedDate(format: String) -> String {
        let dateformat = DateFormatter()
        dateformat.dateFormat = format
        return dateformat.string(from: self)
    }
    func getTimeOfDay() -> String {
        let hour = self.get(.hour)
        var timeOfDay = ""
        switch hour {
        case 6..<12 : timeOfDay = "Morning"
        case 12 : timeOfDay = "Noon"
        case 13..<17 : timeOfDay = "Afternoon"
        case 17..<22 : timeOfDay = "Evening"
        default: timeOfDay = "Night"
        }
        return timeOfDay
    }
}
