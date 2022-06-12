//
//  File.swift
//  
//
//  Created by Andreas Ink on 6/11/22.
//

import Foundation
import SFSafeSymbols

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
