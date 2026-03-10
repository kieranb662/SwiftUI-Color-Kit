//
//  HSBColorPicker.swift
//  MyExamples
//
//  Created by Kieran Brown on 4/7/20.
//  Copyright © 2020 BrownandSons. All rights reserved.
//

import SwiftUI
import Sliders

public struct HueSliderStyle: LSliderStyle {
    public var sliderHeight: CGFloat
    
    private let hueColors = stride(from: 0, to: 1, by: 0.03).map {
        Color(hue: $0, saturation: 1, brightness: 1)
    }
    
    public func makeThumb(configuration: LSliderConfiguration) -> some View {
        return ZStack {
            Circle()
                .fill(Color.white)
                .shadow(radius: 2)
            Circle()
                .fill(Color(hue: configuration.pctFill, saturation: 1, brightness: 1))
                .scaleEffect(0.8)
        }
        .frame(width: sliderHeight, height: sliderHeight)
    }
    
    public func makeTrack(configuration: LSliderConfiguration) -> some View {
        let gradient = LinearGradient(
            gradient: Gradient(colors: hueColors),
            startPoint: .leading,
            endPoint: .trailing
        )
        
        return AdaptiveLine(angle: configuration.angle)
            .stroke(gradient, style: StrokeStyle(lineWidth: sliderHeight, lineCap: .round))
            .overlay(GeometryReader { proxy in
                Capsule()
                    .stroke(Color.white)
                    .frame(width: proxy.size.width + sliderHeight)
                    .rotationEffect(configuration.angle)
            })
    }
}

public struct SaturationBrightnessStyle: TrackPadStyle {
    public var hue: Double
    
    private var saturationColors: [Color] {
        return stride(from: 0, to: 1, by: 0.01).map {
            Color(hue: hue, saturation: $0, brightness: 1)
        }
    }
    
    public func makeThumb(configuration: TrackPadConfiguration) -> some View {
        ZStack {
            Circle()
                .foregroundColor(configuration.isActive ? .yellow : .white)
            
            Circle()
                .fill(
                    Color(
                        hue: hue,
                        saturation: Double(configuration.pctX),
                        brightness: Double(configuration.pctY)
                    )
                )
                .scaleEffect(0.8)
        }
        .frame(width: 40, height: 40)
    }
    
    // FIXME: Come back and draw the 2D gradient with metal when I make a better pipeline
    public func makeTrack(configuration: TrackPadConfiguration) -> some View {
        let brightnessGradient = LinearGradient(
            gradient: Gradient(colors: [Color(red: 1, green: 1, blue: 1), Color(red: 0, green: 0, blue: 0)]),
            startPoint: .bottom,
            endPoint: .top
        )
        let saturationGradient = LinearGradient(
            gradient: Gradient(colors: saturationColors),
            startPoint: .leading,
            endPoint: .trailing
        )
        
        return ZStack {
            RoundedRectangle(cornerRadius: 5)
                .fill(brightnessGradient)
            
            RoundedRectangle(cornerRadius: 5)
                .fill(saturationGradient)
                .drawingGroup(opaque: false, colorMode: .extendedLinear)
                .blendMode(.plusDarker)
        }
        .overlay(RoundedRectangle(cornerRadius: 5).stroke(Color.white, lineWidth: 2))
    }
}


public struct HSBColorPicker: View {
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
        VStack(spacing: 30) {
            TrackPad(
                value: Binding(
                    get: { CGPoint(x: color.saturation, y: color.brightness) },
                    set: { (new) in
                        color = color.update(saturation: Double(new.x))
                        color = color.update(brightness: Double(new.y))
                        
                    }),
                rangeX: 0.01...1, rangeY: 0.01...1)
            .trackPadStyle(SaturationBrightnessStyle(hue: color.hue))
            
            LSlider(Binding(get: { color.hue }, set: { color = color.update(hue: $0) }))
                .linearSliderStyle(HueSliderStyle(sliderHeight: sliderHeight))
                .frame(height: sliderHeight)
                .padding(.horizontal, sliderHeight/2)
        }
    }
}
