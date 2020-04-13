//
//  RGBColorPicker.swift
//  MyExamples
//
//  Created by Kieran Brown on 4/7/20.
//  Copyright © 2020 BrownandSons. All rights reserved.
//

import SwiftUI
import Shapes
import Sliders

@available(iOS 13.0, macOS 10.15, watchOS 6.0 , *)
struct RGBSliderStyle: LSliderStyle {
    enum ColorType: String, CaseIterable {
        case red
        case green
        case blue
    }
    var strokeWidth: CGFloat
    var type: ColorType
    var color: ColorToken
    var colors: [Color] {
        switch type {
        case .red:
            return [Color(self.color.rgbColorSpace.space, red: 0, green: color.green, blue: color.blue),
                    Color(self.color.rgbColorSpace.space, red: 1, green: color.green, blue: color.blue)]
        case .green:
            return [Color(self.color.rgbColorSpace.space, red: color.red, green: 0, blue: color.blue),
                    Color(self.color.rgbColorSpace.space, red: color.red, green: 1, blue: color.blue)]
        case .blue:
            return [Color(self.color.rgbColorSpace.space, red: color.red, green: color.green, blue: 0),
                    Color(self.color.rgbColorSpace.space, red: color.red, green: color.green, blue: 1)]
        }
    }
    
    func makeThumb(configuration: LSliderConfiguration) -> some View {
        let currentColor: Color =  {
            switch type {
            case .red:
                return Color(self.color.rgbColorSpace.space, red: Double(configuration.pctFill), green: 0, blue: 0)
            case .green:
                return Color(self.color.rgbColorSpace.space, red: 0, green: Double(configuration.pctFill), blue: 0)
            case .blue:
                return Color(self.color.rgbColorSpace.space, red: 0, green: 0, blue: Double(configuration.pctFill))
            }
        }()
        
        
        return ZStack {
            Circle()
                .fill(Color.white)
                .shadow(radius: 2)
            Circle()
                .fill(currentColor)
                .scaleEffect(0.8)
        }.frame(width: strokeWidth, height: strokeWidth)
    }

    func makeTrack(configuration: LSliderConfiguration) -> some View {
        let style: StrokeStyle = .init(lineWidth: strokeWidth, lineCap: .round)
        let gradient = LinearGradient(gradient: Gradient(colors: colors), startPoint: .leading, endPoint: .trailing)
        return AdaptiveLine(angle: configuration.angle)
            .stroke(gradient, style: style)
            .overlay(GeometryReader { proxy in
                Capsule()
                    .stroke(Color.white)
                    .frame(width: proxy.size.width + self.strokeWidth)
                    .rotationEffect(configuration.angle)
            })
    }
}
@available(iOS 13.0, macOS 10.15, watchOS 6.0 , *)
public struct RGBColorPicker: View {
    @Binding public var color: ColorToken
    public var sliderHeights: CGFloat = 40
    
    func makeSlider( _ color: RGBSliderStyle.ColorType) -> some View {
        let value: Binding<Double> =  {
            switch color {
            case .red:
                return Binding(get: {self.color.red},
                               set: {self.color = self.color.update(red: $0)})
            case .blue:
                return Binding(get: {self.color.blue},
                               set: {self.color = self.color.update(blue: $0)})
            case .green:
                return Binding(get: {self.color.green},
                               set: {self.color = self.color.update(green: $0)})
            }
        }()
        
        return LSlider(value, range: 0...1, angle: .zero)
            .linearSliderStyle(RGBSliderStyle(strokeWidth: sliderHeights, type: color, color: self.color))
            .frame(height: sliderHeights)
       }
    
    public var body: some View {
        VStack(spacing: 20){
            makeSlider( .red)
            makeSlider(.green)
            makeSlider(.blue)
        }
    }
}

