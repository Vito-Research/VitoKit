//
//  SwiftUIView.swift
//  
//
//  Created by Andreas Ink on 6/11/22.
//

import SwiftUI
import SFSafeSymbols

public struct DataTypesListView: View {
    
    @State public var toggleData: [ToggleData]
    
    @State public var title: String
    
    @State public var caption: String
    
    public init(toggleData: [ToggleData], title: String, caption: String) {
        self.toggleData = toggleData
        self.title = title
        self.caption = caption
    }
    
    public var body: some View {
        VStack {
            Group {
               Text(title)
                .font(.title.bold())
            Text(caption)
             .font(.caption.bold())
             .padding(.horizontal)
             .padding(.horizontal)
             .fixedSize(horizontal: false, vertical: true)
            } .padding()
            Spacer()
            ForEach(toggleData.indices, id:\.self) { i in
                Button(action: {
                    withAnimation(.beat) {
                    if !(toggleData[i].toggle) {
                        toggleData[i].toggle = true
                    } else {
                        toggleData[i].toggle = false
                    }
                    }
                }) {
                    VStack {
                HStack {
                    
                    Image(systemSymbol: toggleData[i].explanation.image)
                        .font(.title.bold())
                        .frame(width: 75)
                    if !toggleData[i].explanation.explanation.isEmpty {
                    Text(toggleData[i].explanation.explanation)
                        .multilineTextAlignment(.leading)
                        .font(.headline)
                    }
                    Spacer()
                }
                    if (toggleData[i].toggle) {
                HStack {
                    
                    Text(toggleData[i].explanation.detail)
                        .font(.caption.bold())
                    .fixedSize(horizontal: false, vertical: true)
                    .foregroundColor(Color.blue.opacity(0.6))
                    .padding(.top)
                    .padding(.leading)
                    .multilineTextAlignment(.leading)
                    Spacer()
                }
                    }
                    }
               // Divider()
            }
                Spacer()
        } .padding()
            Button("APPROVE") {
                Task {
                    do {
                        await try Vito().authorize()
                    } catch {
                        
                    }
                }
            } .buttonStyle(VitoBtnStyle())
              
        }
    }


}
