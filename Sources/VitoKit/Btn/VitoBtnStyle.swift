//
//  SwiftUIView.swift
//  
//
//  Created by Andreas Ink on 6/11/22.
//

import SwiftUI
import SFSafeSymbols

public struct Point: Hashable {
    var x: Int
    var y: Int
    var degree: CGFloat = 0
    var color: Color = .accentColor
    
}
extension Animation {
    static var beat = Animation.interpolatingSpring(mass: 0.13, stiffness: 5.7, damping: 1.2, initialVelocity: 10.0)
}
public struct VitoBtnStyle: ButtonStyle {
    
    @State public var icons: [SFSymbol]
    public init(icons: [SFSymbol]) {
        self.icons = icons
    }
    
    @State public var points = [Point( x: 80, y: 30, degree: CGFloat.random(in: 20...30), color: .teal.opacity(0.6)), Point(x: -90, y: 30, degree: CGFloat.random(in: 60...70), color: .teal), Point( x: 85, y: -40, degree: CGFloat.random(in: 30...60), color: .purple), Point( x: -90, y: -30, degree: CGFloat.random(in: 30...30), color: .purple.opacity(0.6))]
      
       @State public var scale = 1.0
    
    public func makeBody(configuration: Configuration) -> some View {
        ZStack {
            RoundedRectangle(cornerRadius: 25).foregroundColor(Color.accentColor)
        configuration.label
            .font(.system(.headline))
            .foregroundColor(.white)
            //.padding()
           // .padding(.horizontal)
            .scaleEffect(configuration.isPressed ? 1.1 : 1)
           
       
    } .scaleEffect(configuration.isPressed ? 1.02 : 1)
            .frame(minHeight: 60, maxHeight: 80)
            .padding()
            .overlay(
                ZStack {
               
                    ForEach(Array(zip(points, icons)), id: \.0) { point, icon in
                        ZStack {
                            Image(systemSymbol: icon)
                                .font(.largeTitle.bold())
                            
                                            .offset(x: configuration.isPressed ? CGFloat(point.x)  : 0, y: configuration.isPressed ? CGFloat(point.y)  : 0)
                                            .rotation3DEffect(.degrees(5), axis: (x: CGFloat.random(in: -10..<0), y: CGFloat.random(in: -10..<0), z: CGFloat.random(in: -10..<0)), anchor: UnitPoint.trailing, anchorZ: 0, perspective: 0.1)
                                            .scaleEffect(configuration.isPressed ? 1 : 0)
                                            .foregroundColor(point.color)
                                            .animation(.beat, value: configuration.isPressed )
                                            
                                    }
                    
                        .rotation3DEffect(.degrees(configuration.isPressed ? point.degree : 0), axis: (x: 0, y: configuration.isPressed  ? -1 : 0, z: 0), anchor: UnitPoint.leading, anchorZ: 0, perspective: -0.1)
                }
                } .onChange(of: configuration.isPressed, perform: { newValue in
                    if !newValue {
                        points = [Point( x: 80, y: 30, degree: CGFloat.random(in: 20...30), color: .teal.opacity(0.6)), Point(x: -90, y: 30, degree: CGFloat.random(in: 60...70), color: .teal), Point( x: 85, y: -40, degree: CGFloat.random(in: 30...60), color: .purple), Point( x: -90, y: -30, degree: CGFloat.random(in: 30...30), color: .purple.opacity(0.6))]
                    }
                })
               
            )
    }
}

