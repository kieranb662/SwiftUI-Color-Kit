//
//  AlphaSlider.swift
//  MyExamples
//
//  Created by Kieran Brown on 4/7/20.
//  Copyright © 2020 BrownandSons. All rights reserved.
//

import SwiftUI
import Sliders


@available(iOS 13.0, macOS 10.15, watchOS 6.0 , *)
public struct AlphaSliderStyle: LSliderStyle {
    public var color: ColorToken
    public var sliderHeight: CGFloat = 40
    private var gradient: Gradient { Gradient(colors: [Color.white.opacity(0), Color.white]) }
    
    public func makeThumb(configuration: LSliderConfiguration) -> some View {
        ZStack {
            Circle()
                .fill(Color.white)
            Circle()
                .inset(by: 3)
                .fill(color.color)
        }
        .frame(width: sliderHeight, height: sliderHeight)
    }
    public var blockHeight: CGFloat = 10
    
    public func makeTrack(configuration: LSliderConfiguration) -> some View {
        GeometryReader { proxy in
            ZStack {
                VStack(spacing: 0) {
                    ForEach(0..<max(Int(proxy.size.height/self.blockHeight), 2)) { (v: Int)  in
                        HStack(spacing: 0) {
                            ForEach(0..<max(Int((proxy.size.width+self.sliderHeight)/self.blockHeight), 2), id: \.self) { (h: Int) in
                                Rectangle()
                                    .fill( h % 2 == 0 ? v % 2 == 0 ? Color.black : Color.white : v % 2 == 0 ? Color.white : Color.black).frame(width: self.blockHeight, height: self.blockHeight).tag(h)
                            }
                        }
                    }
                }
                LinearGradient(gradient: self.gradient, startPoint: .leading, endPoint: .trailing)
            }
            .drawingGroup()
            .mask(Capsule().fill())
            .frame(width: proxy.size.width + self.sliderHeight, height: self.sliderHeight)
                .overlay(
                    Capsule()
                        .stroke(Color.white, lineWidth: 1)
                        .frame(width: proxy.size.width + self.sliderHeight)
                )
        }
    }
}
@available(iOS 13.0, macOS 10.15, watchOS 6.0 , *)
public struct AlphaSlider: View {
    @Binding public var color: ColorToken
    public var sliderHeight: CGFloat = 40
    
    public init(_ color: Binding<ColorToken>) {
        self._color = color
    }
    
    public init(_ color: Binding<ColorToken>, sliderHeight: CGFloat) {
        self._color = color
        self.sliderHeight = sliderHeight
    }
    
    public var body: some View {
        LSlider(Binding(get: { self.color.alpha }, set: { self.color = self.color.update(alpha: $0) }))
            .linearSliderStyle(AlphaSliderStyle(color: color, sliderHeight: sliderHeight))
     
    }
}
