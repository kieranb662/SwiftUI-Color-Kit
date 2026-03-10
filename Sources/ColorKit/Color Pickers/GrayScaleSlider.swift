//
//  GrayScaleSlider.swift
//  MyExamples
//
//  Created by Kieran Brown on 4/8/20.
//  Copyright © 2020 BrownandSons. All rights reserved.
//

import SwiftUI
import Sliders

public struct GrayScaleSliderStyle: LSliderStyle {
    public let color: ColorToken
    public let sliderHeight: CGFloat
    private var gradient: Gradient { Gradient(colors: [Color(white: 0), Color(white: 1)]) }
    
    public func makeThumb(configuration: LSliderConfiguration) -> some View {
        ZStack {
            Pentagon()
                .fill(color.color)
            
            Pentagon()
                .stroke(
                    Color(white: color.white < 0.6 ? 1 : 1-color.white),
                    style: StrokeStyle(lineWidth: 3, lineJoin: .round)
                )
        }
        .frame(width: sliderHeight/2, height: 0.66*sliderHeight)
        .offset(x: 0, y: 0.16*sliderHeight-1.5)
    }
    
    public func makeTrack(configuration: LSliderConfiguration) -> some View {
        ZStack {
            RoundedRectangle(cornerRadius: 5)
                .fill(LinearGradient(gradient: gradient, startPoint: .leading, endPoint: .trailing))
            
            RoundedRectangle(cornerRadius: 5)
                .stroke(Color.gray)
        }
    }
}

public struct GrayScaleSlider: View {
    @Binding private var color: ColorToken
    private var sliderHeight: CGFloat = 40
    
    public init(_ color: Binding<ColorToken>) {
        self._color = color
    }
    
    public init(_ color: Binding<ColorToken>, sliderHeight: CGFloat) {
        self._color = color
        self.sliderHeight = sliderHeight
    }
    
    public var body: some View {
        LSlider(
            Binding(get: { color.white }, set: { color = color.update(white: $0) })
        )
        .linearSliderStyle(GrayScaleSliderStyle(color: color, sliderHeight: sliderHeight))
    }
}

struct Pentagon: Shape {
    /// Creates a square bottomed pentagon.
    init() {}
    
    var insetAmount: CGFloat = 0
    
    func path(in rect: CGRect) -> Path {
        let insetRect: CGRect = rect.insetBy(dx: insetAmount, dy: insetAmount)
        let w = insetRect.width
        let h = insetRect.height
        
        return Path { path in
            path.move(to:    CGPoint(x: w/2, y:   0))
            path.addLine(to: CGPoint(x:   0, y: h/2))
            path.addLine(to: CGPoint(x:   0, y:   h))
            path.addLine(to: CGPoint(x:   w, y:   h))
            path.addLine(to: CGPoint(x:   w, y: h/2))
            path.closeSubpath()
        }
        .offsetBy(dx: insetAmount, dy: insetAmount)
    }
}

extension Pentagon: InsettableShape {
    func inset(by amount: CGFloat) -> some InsettableShape {
        var shape = self
        shape.insetAmount += amount
        return shape
    }
}
