//
//  CYMKColorPicker.swift
//  MyExamples
//
//  Created by Kieran Brown on 4/7/20.
//  Copyright © 2020 BrownandSons. All rights reserved.
//

import SwiftUI
import Shapes
import Sliders

@available(iOS 13.0, macOS 10.15, watchOS 6.0 , *)
struct CMYKSliderStyle: LSliderStyle {
    var strokeWidth: CGFloat
    var type: ColorType
    var color: ColorToken
    var colors: [Color] {
        switch type {
            
        case .cyan:
            return [Color(PlatformColor(cmyk: (0,CGFloat(color.magenta), CGFloat(color.yellow), CGFloat(color.keyBlack) ))), Color(PlatformColor(cmyk: (1,CGFloat(color.magenta), CGFloat(color.yellow), CGFloat(color.keyBlack) )))]
        case .magenta:
            return [Color(PlatformColor(cmyk: (CGFloat(color.cyan),0, CGFloat(color.yellow), CGFloat(color.keyBlack) ))), Color(PlatformColor(cmyk: (CGFloat(color.cyan),1, CGFloat(color.yellow), CGFloat(color.keyBlack) )))]
        case .yellow:
            return [Color(PlatformColor(cmyk: (CGFloat(color.cyan),CGFloat(color.magenta), 0, CGFloat(color.keyBlack) ))), Color(PlatformColor(cmyk: (CGFloat(color.cyan),CGFloat(color.magenta), 1, CGFloat(color.keyBlack) )))]
        case .black:
            return [Color(PlatformColor(cmyk: (CGFloat(color.cyan),CGFloat(color.magenta), CGFloat(color.yellow), 0))), Color(PlatformColor(cmyk: (CGFloat(color.cyan),CGFloat(color.magenta), CGFloat(color.yellow), 1)))]
            
        }
    }
    enum ColorType: String, CaseIterable {
        case cyan
        case magenta
        case yellow
        case black
    }
    
    func makeThumb(configuration: LSliderConfiguration) -> some View {
        let currentColor: Color =  {
            switch type {
            case .cyan:
                return Color(PlatformColor(cmyk: (CGFloat(configuration.pctFill), 0 , 0, 0)))
            case .magenta:
                return Color(PlatformColor(cmyk: (0,CGFloat(configuration.pctFill), 0, 0)))
            case .yellow:
                return Color(PlatformColor(cmyk: (0, 0, CGFloat(configuration.pctFill), 0)))
            case .black:
                return Color(PlatformColor(cmyk: (0, 0, 0, CGFloat(configuration.pctFill))))
            }
        }()
        
        return ZStack {
            Circle()
                .fill(Color.white)
                .shadow(radius: 2)
            Circle()
                .fill(currentColor)
                .scaleEffect(0.8)
        }.frame(width: self.strokeWidth, height: self.strokeWidth)
    }
    
    func makeTrack(configuration: LSliderConfiguration) -> some View {
        let style: StrokeStyle = .init(lineWidth: strokeWidth, lineCap: .round)
        return AdaptiveLine(angle: configuration.angle)
            .stroke(LinearGradient(gradient: Gradient(colors: colors), startPoint: .leading, endPoint: .trailing), style: style)
            .overlay(GeometryReader { proxy in
                Capsule()
                    .stroke(Color.white)
                    .frame(width: proxy.size.width + self.strokeWidth)
                    .rotationEffect(configuration.angle)
            })
    }
    
}

@available(iOS 13.0, macOS 10.15, watchOS 6.0 , *)
struct CMYKColorPicker: View {
    @Binding var color: ColorToken
    var sliderHeights: CGFloat = 40

    init(_ color: Binding<ColorToken>) {
        self._color = color
    }
    
    func makeSlider( _ color: CMYKSliderStyle.ColorType) -> some View {
        let value: Binding<Double> =  {
            switch color {
            case .cyan:
                return Binding(get: {self.color.cyan},
                               set: {self.color = self.color.update(cyan: $0)})
            case .magenta:
                return Binding(get: {self.color.magenta},
                               set: {self.color = self.color.update(magenta: $0)})
            case .yellow:
                return Binding(get: {self.color.yellow},
                               set: {self.color = self.color.update(yellow: $0)})
            case .black:
                return Binding(get: {self.color.keyBlack},
                               set: {self.color = self.color.update(keyBlack: $0)})
            }
        }()
        let style = CMYKSliderStyle(strokeWidth: sliderHeights, type: color, color: self.color)
        return LSlider(value)
            .linearSliderStyle(style)
            .frame(height: sliderHeights)
    }
    
    var body: some View {
        VStack(spacing: 20){
            makeSlider( .cyan)
            makeSlider(.magenta)
            makeSlider(.yellow)
            makeSlider(.black)
        }
    }
}

