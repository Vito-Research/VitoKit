//
//  File.swift
//
//
//  Created by Andreas Ink on 6/11/22.
//

import Foundation
import SFSafeSymbols

// Utilized in RequestView
public struct ToggleData: Identifiable, Hashable {
    public init(id: UUID, toggle: Bool, explanation: Explanation) {
        self.id = id
        self.toggle = toggle
        self.explanation = explanation
    }

    public var id: UUID
    public var toggle: Bool
    public var explanation: Explanation
}

public extension ToggleData {
    static var Mobilty = ToggleData(id: UUID(), toggle: false, explanation: Explanation(image: .figureWalk, explanation: "Learn from your mobility", detail: "More details here"))

    static var Vitals = ToggleData(id: UUID(), toggle: false, explanation: Explanation(image: .heart, explanation: "Vito uses vital trends to measure stress", detail: "This is not a perfect tool, however, generally, stress may be indicative of infection, distress, etc."))

    static var Activity = ToggleData(id: UUID(), toggle: false, explanation: Explanation(image: .bolt, explanation: "Vito uses your activity data to give context to stress", detail: ""))
}

public struct Explanation: Hashable {
    public init(image: SFSymbol, explanation: String, detail: String) {
        self.image = image
        self.explanation = explanation
        self.detail = detail
    }

    public var image: SFSymbol
    public var explanation: String
    public var detail: String
}
