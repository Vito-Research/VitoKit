//
//  File.swift
//
//
//  Created by Andreas Ink on 6/13/22.
//

import Accelerate
import Foundation

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
        state = .Zero(Alert())
    }

    // Drops state to level zero
    mutating func resetAlert() {
        switch state {
        case let .Five(alert):
            state = .Zero(alert)
        case let .Four(alert):
            state = .Zero(alert)
        case let .Three(alert):
            state = .Zero(alert)
        case let .Two(alert):
            state = .Zero(alert)
        case let .One(alert):
            state = .Zero(alert)

        default:
            break
        }
    }

    // Returns number of alerts
    func returnNumberOfAlerts() -> Int {
        switch state {
        case let .Five(alert):
            return alert.hr.count
        case let .Four(alert):
            return alert.hr.count

        default:
            return 0
        }
    }

    // Returns current alert level, only send an alert if level 5 and two days above alert level 5
    func returnAlert() -> Double {
        switch state {
        case let .Five(alert):
            return alert.clusterCount > 1 ? 1 : 0

        default:
            return 0
        }
    }

    // Calculates median to populate alert
    mutating func calculateMedian(_ hr: Int, _: Date?, yellowThres: Float, redThres: Float) -> Double {
        switch state {
        case var .Five(alert):

            alert.hr.append(hr)
            // Checks if data count is above 10
            if alert.hr.count > 10 {
                if let median = calculateMedian(array: alert.hr.map { Double($0) }) {
                    if Float(hr) >= median + redThres {
                        alert.clusterCount += 1

                        state = .Five(alert)
                        if alert.clusterCount > 2 {
                            alert.clusterCount = 0
                            return 1
                        } else {
                            return 0
                        }

                    } else if Float(hr) == median + yellowThres {
                        state = .Three(Alert(hr: alert.hr))
                    } else {
                        state = .Zero(Alert(hr: alert.hr))
                    }
                }
            } else {
                state = .Zero(Alert(hr: alert.hr))
            }

        case var .Four(alert):

            alert.clusterCount = 0
            alert.hr.append(hr)
            if alert.hr.count > 10 {
                if let median = calculateMedian(array: alert.hr.map { Double($0) }) {
                    if Float(hr) >= median + redThres {
                        state = .Five(alert)
                        return 1
                    } else if Float(hr) == median + yellowThres {
                        state = .Three(Alert(hr: alert.hr))
                    } else {
                        state = .Zero(Alert(hr: alert.hr))
                    }
                }
            } else {
                state = .Zero(Alert(hr: alert.hr))
            }
            return 0

        case var .Three(alert):
            alert.clusterCount = 0
            alert.hr.append(hr)
            if alert.hr.count > 10 {
                if let median = calculateMedian(array: alert.hr.map { Double($0) }) {
                    if Float(hr) >= median + redThres {
                        state = .Four(alert)

                    } else if Float(hr) == median + yellowThres {
                        state = .Three(Alert(hr: alert.hr))
                    } else {
                        state = .Zero(Alert(hr: alert.hr))
                    }
                }
            } else {
                state = .Zero(Alert(hr: alert.hr))
            }
            return 0

        case var .Two(alert):
            alert.clusterCount = 0
            alert.hr.append(hr)
            if alert.hr.count > 10 {
                if let median = calculateMedian(array: alert.hr.map { Double($0) }) {
                    if Float(hr) >= median + redThres {
                        state = .Five(alert)
                        return 1
                    } else if Float(hr) == median + yellowThres {
                        state = .Three(Alert(hr: alert.hr))
                    } else {
                        state = .Zero(Alert(hr: alert.hr))
                    }
                }
            } else {
                state = .Zero(Alert(hr: alert.hr))
            }
            return 0

        case var .One(alert):
            alert.clusterCount = 0
            alert.hr.append(hr)
            if alert.hr.count > 10 {
                if let median = calculateMedian(array: alert.hr.map { Double($0) }) {
                    if Float(hr) >= median + redThres {
                        state = .Four(alert)

                    } else if Float(hr) == median + yellowThres {
                        state = .Three(Alert(hr: alert.hr))
                    } else {
                        state = .Zero(Alert(hr: alert.hr))
                    }
                }
            } else {
                state = .Zero(Alert(hr: alert.hr))
            }
            return 0

        case var .Zero(alert):
            alert.clusterCount = 0
            alert.hr.append(hr)
            if alert.hr.count > 10 {
                if let median = calculateMedian(array: alert.hr.map { Double($0) }) {
                    if Float(hr) >= median + redThres {
                        state = .Two(alert)

                    } else if Float(hr) == median + yellowThres {
                        state = .One(Alert(hr: alert.hr))
                    } else {
                        state = .Zero(Alert(hr: alert.hr))
                    }
                } else {
                    state = .Zero(Alert(hr: alert.hr))
                }
            } else {
                state = .Zero(Alert(hr: alert.hr))
            }

            return 0
        }
        return 0
    }

    // Calculates median of an arr of doubles
    func calculateMedian(array: [Double]) -> Float? {
        let sorted = array.sorted().filter { !$0.isNaN }
        if !sorted.isEmpty {
            if sorted.count % 2 == 0 {
                return Float(sorted[sorted.count / 2] + sorted[(sorted.count / 2) - 1]) / 2
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
