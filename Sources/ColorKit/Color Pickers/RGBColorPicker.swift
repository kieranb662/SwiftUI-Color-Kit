// Swift toolchain version 6.0
// Running macOS version 26.3
// Created on 4/7/20.
//
// Author: Kieran Brown
//

import SwiftUI
import Sliders

public struct RGBSliderStyle: LSliderStyle {
    
    public enum ColorType: String, CaseIterable, Sendable {
        case red
        case green
        case blue
    }
    
    public var sliderHeight: CGFloat
    public var type: ColorType
    public var color: ColorToken
    
    // Creates two colors based upon what the color would look like if the value of the slider was dragged all the way left or all the way right
    private var colors: [Color] {
        switch type {
        case .red:
            return [Color(color.rgbColorSpace.space, red: 0, green: color.green, blue: color.blue),
                    Color(color.rgbColorSpace.space, red: 1, green: color.green, blue: color.blue)]
        case .green:
            return [Color(color.rgbColorSpace.space, red: color.red, green: 0, blue: color.blue),
                    Color(color.rgbColorSpace.space, red: color.red, green: 1, blue: color.blue)]
        case .blue:
            return [Color(color.rgbColorSpace.space, red: color.red, green: color.green, blue: 0),
                    Color(color.rgbColorSpace.space, red: color.red, green: color.green, blue: 1)]
        }
    }
    
    public func makeThumb(configuration: LSliderConfiguration) -> some View {
        let currentColor: Color =  {
            switch type {
            case .red:
                return Color(color.rgbColorSpace.space, red: Double(configuration.pctFill), green: 0, blue: 0)
            case .green:
                return Color(color.rgbColorSpace.space, red: 0, green: Double(configuration.pctFill), blue: 0)
            case .blue:
                return Color(color.rgbColorSpace.space, red: 0, green: 0, blue: Double(configuration.pctFill))
            }
        }()
        
        return ZStack {
            Circle()
                .fill(Color.white)
                .shadow(radius: 2)
            Circle()
                .fill(currentColor)
                .scaleEffect(0.8)
        }
        .frame(width: sliderHeight, height: sliderHeight)
    }
    
    public func makeTrack(configuration: LSliderConfiguration) -> some View {
        let gradient = LinearGradient(
            gradient: Gradient(colors: colors),
            startPoint: .leading,
            endPoint: .trailing
        )
        
        return AdaptiveLine(angle: configuration.angle)
            .stroke(gradient, style: StrokeStyle(lineWidth: sliderHeight, lineCap: .round))
            .overlay(
                GeometryReader { proxy in
                    Capsule()
                        .stroke(Color.white)
                        .frame(width: proxy.size.width + sliderHeight)
                        .rotationEffect(configuration.angle)
                }
            )
    }
}

public struct RGBColorPicker: View {
    @Binding public var color: ColorToken
    public var sliderHeights: CGFloat = 40
    
    public init(_ color: Binding<ColorToken>) {
        self._color = color
    }
    
    public init(_ color: Binding<ColorToken>, sliderHeights: CGFloat) {
        self._color = color
        self.sliderHeights = sliderHeights
    }
    
    private func makeSlider( _ colorType: RGBSliderStyle.ColorType) -> some View {
        let value: Binding<Double> =  {
            switch colorType {
            case .red:
                return Binding(get: { color.red },
                               set: { color = color.update(red: $0) })
            case .blue:
                return Binding(get: { color.blue },
                               set: { color = color.update(blue: $0) })
            case .green:
                return Binding(get: { color.green },
                               set: { color = color.update(green: $0) })
            }
        }()
        
        return LSlider(value, range: 0...1, angle: .zero)
            .linearSliderStyle(RGBSliderStyle(sliderHeight: sliderHeights, type: colorType, color: color))
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

