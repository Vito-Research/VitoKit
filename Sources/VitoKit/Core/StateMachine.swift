//
//  File.swift
//  
//
//  Created by Andreas Ink on 6/13/22.
//

import Foundation
import Accelerate

@MainActor
struct StateMachine {
    
    // Inital level
    private var state: Level
    
    enum Level {
        case Zero(Alert)
        case One(Alert)
        case Two(Alert)
        case Three(Alert)
        case Four(Alert)
        case Five(Alert)
    }

    struct Alert {
        var clusterCount: Int = 0
        var hr: [Int] = []
        
    }
    
    init() {
        // On initalize, set state to zero with no clusters or data
        self.state = .Zero(Alert())
    }
    
    // Drops state to level zero
    mutating func resetAlert() {
        switch self.state {
        case .Five(let alert):
            self.state = .Zero(alert)
        case .Four(let alert):
            self.state = .Zero(alert)
        case .Three(let alert):
            self.state = .Zero(alert)
        case .Two(let alert):
            self.state = .Zero(alert)
        case .One(let alert):
            self.state = .Zero(alert)
            
            
        default:
            break
        }
    }
    
    // Returns number of alerts
    func returnNumberOfAlerts() -> Int {
        switch self.state {
        case .Five(var alert):
            return alert.hr.count
        case .Four(var alert):
            return alert.hr.count
            
        default:
            return 0
        }
    }
    // Returns current alert level, only send an alert if level 5 and two days above alert level 5
    func returnAlert() -> Double {
        switch self.state {
        case .Five(let alert):
            return alert.clusterCount > 1 ? 1 : 0
            
        default:
            return 0
        }
    }
    // Calculates median to populate alert
    mutating func calculateMedian(_ hr: Int, _ date: Date?, yellowThres: Float, redThres: Float) -> Double {
        
        switch self.state {
            
        case .Five(var alert):
            
            alert.hr.append(hr)
            // Checks if data count is above 10
            if alert.hr.count > 10 {
                if let median = calculateMedian(array: alert.hr.map{Double($0)}) {
                    
                    if Float(hr) >= (median) + redThres {
                        
                        alert.clusterCount += 1
                        
                        self.state = .Five(alert)
                        if alert.clusterCount > 2 {
                            alert.clusterCount = 0
                            return 1
                        } else {
                            return 0
                        }
                        
                    } else if Float(hr) == (median) + yellowThres {
                        
                        self.state = .Three(Alert(hr: alert.hr))
                    } else {
                        self.state = .Zero(Alert(hr: alert.hr))
                    }
                }
            } else {
                self.state = .Zero(Alert(hr: alert.hr))
            }
            
            
            
        case .Four(var alert):
            
            alert.clusterCount = 0
            alert.hr.append(hr)
            if alert.hr.count > 10 {
                if let median = calculateMedian(array: alert.hr.map{Double($0)}) {
                    
                    if Float(hr) >= (median) + redThres {
                        
                        self.state = .Five(alert)
                        return 1
                    } else if Float(hr) == (median) + yellowThres {
                        
                        self.state = .Three(Alert(hr: alert.hr))
                    } else {
                        
                        self.state = .Zero(Alert(hr: alert.hr))
                    }
                }
            } else {
                self.state = .Zero(Alert(hr: alert.hr))
            }
            return 0
            
        case .Three(var alert):
            alert.clusterCount = 0
            alert.hr.append(hr)
            if alert.hr.count > 10 {
                if let median = calculateMedian(array: alert.hr.map{Double($0)}) {
                    if Float(hr) >= (median) + redThres {
                        
                        self.state = .Four(alert)
                        
                    } else if Float(hr) == (median) + yellowThres {
                        
                        self.state = .Three(Alert(hr: alert.hr))
                    } else {
                        
                        self.state = .Zero(Alert(hr: alert.hr))
                    }
                }
            } else {
                self.state = .Zero(Alert(hr: alert.hr))
            }
            return 0
            
            
        case .Two(var alert):
            alert.clusterCount = 0
            alert.hr.append(hr)
            if alert.hr.count > 10 {
                if let median = calculateMedian(array: alert.hr.map{Double($0)}) {
                    if Float(hr) >= (median) + redThres {
                        
                        
                        
                        
                        
                        self.state = .Five(alert)
                        return 1
                    } else if Float(hr) == (median) + yellowThres {
                        
                        self.state = .Three(Alert(hr: alert.hr))
                    } else {
                        
                        
                        self.state = .Zero(Alert(hr: alert.hr))
                    }
                }
            } else {
                self.state = .Zero(Alert(hr: alert.hr))
            }
            return 0
            
        case .One(var alert):
            alert.clusterCount = 0
            alert.hr.append(hr)
            if alert.hr.count > 10 {
                if let median = calculateMedian(array: alert.hr.map{Double($0)}) {
                    if Float(hr) >= (median) + redThres {
                        
                        self.state = .Four(alert)
                        
                    } else if Float(hr) == (median) + yellowThres {
                        
                        self.state = .Three(Alert(hr: alert.hr))
                    } else {
                        
                        self.state = .Zero(Alert(hr: alert.hr))
                    }
                }
            } else {
                self.state = .Zero(Alert(hr: alert.hr))
            }
            return 0
            
            
        case .Zero(var alert):
            alert.clusterCount = 0
            alert.hr.append(hr)
            if alert.hr.count > 10 {
                if let median = calculateMedian(array: alert.hr.map{Double($0)}) {
                    if Float(hr) >= (median) + redThres {
                        
                        self.state = .Two(alert)
                        
                    } else if Float(hr) == (median) + yellowThres {
                        
                        self.state = .One(Alert(hr: alert.hr))
                    } else {
                        
                        self.state = .Zero(Alert(hr: alert.hr))
                    }
                } else {
                    
                    self.state = .Zero(Alert(hr: alert.hr))
                }
            } else {
                self.state = .Zero(Alert(hr: alert.hr))
            }
            
            return 0
            
        }
        return 0
    }
    // Calculates median of an arr of doubles
    func calculateMedian(array: [Double]) -> Float? {
        let sorted = array.sorted().filter{!$0.isNaN}
        if !sorted.isEmpty {
            if sorted.count % 2 == 0 {
                return Float((sorted[(sorted.count / 2)] + sorted[(sorted.count / 2) - 1])) / 2
            } else {
                return Float(sorted[(sorted.count - 1) / 2])
            }
        }
        
        return nil
    }
    // Calculates average of an arr of doubles
    func average(numbers: [Double]) -> Double {
        
        return vDSP.mean(numbers)
    }
}
