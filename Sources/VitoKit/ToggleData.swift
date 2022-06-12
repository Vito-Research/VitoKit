//
//  File.swift
//  
//
//  Created by Andreas Ink on 6/11/22.
//

import Foundation
import SFSafeSymbols

struct ToggleData: Identifiable, Hashable {
    
    var id: UUID
    var toggle: Bool
    var explanation: Explanation
    
}
struct Explanation: Hashable {
    
    var image: SFSymbol
    var explanation: String
    var detail: String
    
}
