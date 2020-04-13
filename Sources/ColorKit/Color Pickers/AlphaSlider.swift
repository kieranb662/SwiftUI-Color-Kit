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
struct AlphaSliderStyle: LSliderStyle {
    var color: ColorToken
    var strokeWidth: CGFloat = 40
    var gradient: Gradient { Gradient(colors: [Color.white.opacity(0), Color.white]) }
    
    func makeThumb(configuration: LSliderConfiguration) -> some View {
        ZStack {
            Circle()
                .fill(Color.white)
            Circle()
                .inset(by: 3)
                .fill(color.color)
        }
        .frame(width: strokeWidth, height: strokeWidth)
    }
    var blockHeight: CGFloat = 10
    
    func makeTrack(configuration: LSliderConfiguration) -> some View {
        GeometryReader { proxy in
            ZStack {
                VStack(spacing: 0) {
                    ForEach(0..<max(Int(proxy.size.height/self.blockHeight), 2)) { (v: Int)  in
                        HStack(spacing: 0) {
                            ForEach(0..<max(Int((proxy.size.width+self.strokeWidth)/self.blockHeight), 2), id: \.self) { (h: Int) in
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
            .frame(width: proxy.size.width + self.strokeWidth, height: self.strokeWidth)
                .overlay(
                    Capsule()
                        .stroke(Color.white, lineWidth: 1)
                        .frame(width: proxy.size.width + self.strokeWidth)
                )
        }
    }
}
@available(iOS 13.0, macOS 10.15, watchOS 6.0 , *)
struct AlphaSlider: View {
    @Binding var color: ColorToken
    var sliderHeight: CGFloat = 40
    
    var body: some View {
        LSlider(Binding(get: { self.color.alpha }, set: { self.color = self.color.update(alpha: $0) }))
            .linearSliderStyle(AlphaSliderStyle(color: color, strokeWidth: sliderHeight))
     
    }
}
