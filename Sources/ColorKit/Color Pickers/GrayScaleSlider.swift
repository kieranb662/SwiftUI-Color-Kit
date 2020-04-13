//
//  GrayScaleSlider.swift
//  MyExamples
//
//  Created by Kieran Brown on 4/8/20.
//  Copyright © 2020 BrownandSons. All rights reserved.
//

import SwiftUI
import Shapes
import Sliders

@available(iOS 13.0, macOS 10.15, watchOS 6.0 , *)
struct GrayScaleSliderStyle: LSliderStyle {
    let color: ColorToken
    let strokeWidth: CGFloat
    var gradient: Gradient { Gradient(colors: [Color(white: 0), Color(white: 1)]) }
    
    func makeThumb(configuration: LSliderConfiguration) -> some View {
        let strokeColor = Color(white: color.white < 0.6 ? 1 : 1-color.white)
        return ZStack {
            Pentagon()
            .fill(color.color)
            Pentagon()
                .stroke(strokeColor, style: .init(lineWidth: 3, lineJoin: .round))
        }
        .frame(width: strokeWidth/2, height: 0.66*strokeWidth)
        .offset(x: 0, y: 0.16*strokeWidth-1.5)
            
    }
    
    func makeTrack(configuration: LSliderConfiguration) -> some View {
        let fill = LinearGradient(gradient: self.gradient, startPoint: .leading, endPoint: .trailing)
        return ZStack {
            RoundedRectangle(cornerRadius: 5)
                .fill(fill)
            RoundedRectangle(cornerRadius: 5)
            .stroke(Color.gray)
        }
    }
}
@available(iOS 13.0, macOS 10.15, watchOS 6.0 , *)
struct GrayScaleSlider: View {
    @Binding var color: ColorToken
    
    var body: some View {
        LSlider(Binding(get: { self.color.white},
                               set: { self.color = self.color.update(white: $0) }))
            .linearSliderStyle(GrayScaleSliderStyle(color: color, strokeWidth: 40))
    }
}
