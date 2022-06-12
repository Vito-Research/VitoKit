//
//  SwiftUIView.swift
//  
//
//  Created by Andreas Ink on 6/11/22.
//

import SwiftUI

struct VitoBtnStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.system(.headline))
            .foregroundColor(.white)
            .padding()
            .background(RoundedRectangle(cornerRadius: 25).foregroundColor(Color.accentColor))
            .scaleEffect(configuration.isPressed ? 1.1 : 1)
            .overlay(
                if (configuration.isPressed {
                Box3DView()
                }
            )
    }
}

