//
//  SwiftUIView.swift
//  
//
//  Created by Andreas Ink on 6/11/22.
//

import SwiftUI
import SFSafeSymbols

public struct DataTypesListView: View {
    
    @State var toggleData = [ToggleData(id: UUID(), toggle: false, explanation: Explanation(image: .heart, explanation: "Heart Rate", detail: "Abnormally high heart rate while asleep can be a sign of distress from your body")), ToggleData(id: UUID(), toggle: false, explanation: Explanation(image: .lungs, explanation: "Respiratory Rate", detail: "High respiratory rate while asleep can be a sign of distress from your body")), ToggleData(id: UUID(), toggle: false, explanation:  Explanation(image: .person , explanation: "Steps", detail: "Utilized to detect when you are alseep")), ToggleData(id: UUID(), toggle: false, explanation: Explanation(image: .flame, explanation: "Active Energy", detail: "Utilized to detect when you are alseep"))]
    
    public init(toggleData: [ToggleData]) {
        self.toggleData = toggleData
    }
    
    public var body: some View {
        VStack {
            
               
            ForEach(toggleData.indices, id:\.self) { i in
                Button(action: {
                    if !(toggleData[i].toggle) {
                        toggleData[i].toggle = true
                    } else {
                        toggleData[i].toggle = false
                    }
                }) {
                    VStack {
                HStack {
                    
                    Image(systemSymbol: toggleData[i].explanation.image)
                        .font(.title.bold())
                    Text(toggleData[i].explanation.explanation)
                        .multilineTextAlignment(.leading)
                        .font(.headline)
                    Spacer()
                }
                    if (toggleData[i].toggle) {
                HStack {
                    
                    Text(toggleData[i].explanation.detail)
                        .font(.caption)
                    .fixedSize(horizontal: false, vertical: true)
                    .foregroundColor(Color.cyan)
                    .padding(.top)
                    .multilineTextAlignment(.leading)
                    Spacer()
                }
                    }
                    }
                Divider()
            }
        } .padding()
        }
    }


}
