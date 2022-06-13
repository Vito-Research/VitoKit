//
//  File.swift
//  
//
//  Created by Andreas Ink on 6/12/22.
//

import SwiftUI


struct TextAnimation: View {
    
    @State var lettersArr: [Letter]
    @State var speed: Double
    
    @State var showMaterial = true
    @State var showText = true
    
    @State var spacing: Int
    
    @State var isLeading: Bool
   
     @State var showRN = false
    
    @State var colors = [Color]()
     var body: some View {
        VStack(alignment: isLeading ? .leading : .center, spacing: CGFloat(spacing)) {
           // Spacer()
    
   
            VStack {
                ForEach(Array(zip($lettersArr, lettersArr.indices)), id: \.1) { $letter, i in
                    HStack {
                        
                        Text($letter.wrappedValue.letter)
                            .foregroundLinearGradient(
                                colors: $letter.wrappedValue.colors,
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            .font(letter.font)
                            .opacity($letter.wrappedValue.opacity)
                            .multilineTextAlignment(isLeading ? .leading : .center)
                            .fixedSize(horizontal: false, vertical: true)
                            .padding(5)
                            
                            .onAppear() {
                                
                                
                                print(speed)
                                if showRN {
                                    //withAnimation(.easeInOut) {
                                    lettersArr[i].opacity = 1
                                   // }
                                }
                                DispatchQueue.main.asyncAfter(deadline: .now() + TimeInterval(Double(i)/2.0)) {
                                    //playAudio()
                                    withAnimation(.easeInOut(duration: 2.0)) {
                                        lettersArr[i].opacity = 1
                                        

                                    }
                                }
                            }
                        Spacer()
                    }
                }
            }
    
    
    
    
    
    
        } .padding(.horizontal)
    }

}


public struct Letter {
    public init(letter: String, font: Font = .system(.headline), colors: [Color]) {
        self.letter = letter
        self.font = font
        self.colors = colors
    }
    var letter: String = ""
    var opacity: Double = 0.0
    var font: Font = .system(.headline)
    var colors: [Color]
}

extension Text {
    public func foregroundLinearGradient(
        colors: [Color],
        startPoint: UnitPoint,
        endPoint: UnitPoint) -> some View
    {
        self.overlay {

            LinearGradient(
                colors: colors,
                startPoint: startPoint,
                endPoint: endPoint
            )
            .mask(
                self

            )
        }
    }
}
