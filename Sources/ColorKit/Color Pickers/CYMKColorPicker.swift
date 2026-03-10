// Swift toolchain version 6.0
// Running macOS version 26.3
// Created on 4/7/20.
//
// Author: Kieran Brown
//

import SwiftUI
import Sliders

public struct CMYKSliderStyle: LSliderStyle {
    public var sliderHeight: CGFloat
    public var type: ColorType
    public var color: ColorToken
    
    // Creates two colors based upon what the color would look like if the value of the slider was dragged all the way left or all the way right
    private var colors: [Color] {
        switch type {
        case .cyan:
            return [Color(PlatformColor(cmyk: (0, CGFloat(color.magenta), CGFloat(color.yellow), CGFloat(color.keyBlack) ))),
                    Color(PlatformColor(cmyk: (1, CGFloat(color.magenta), CGFloat(color.yellow), CGFloat(color.keyBlack) )))]
        case .magenta:
            return [Color(PlatformColor(cmyk: (CGFloat(color.cyan), 0, CGFloat(color.yellow), CGFloat(color.keyBlack) ))),
                    Color(PlatformColor(cmyk: (CGFloat(color.cyan), 1, CGFloat(color.yellow), CGFloat(color.keyBlack) )))]
        case .yellow:
            return [Color(PlatformColor(cmyk: (CGFloat(color.cyan), CGFloat(color.magenta), 0, CGFloat(color.keyBlack) ))),
                    Color(PlatformColor(cmyk: (CGFloat(color.cyan), CGFloat(color.magenta), 1, CGFloat(color.keyBlack) )))]
        case .black:
            return [Color(PlatformColor(cmyk: (CGFloat(color.cyan), CGFloat(color.magenta), CGFloat(color.yellow), 0))),
                    Color(PlatformColor(cmyk: (CGFloat(color.cyan), CGFloat(color.magenta), CGFloat(color.yellow), 1)))]
            
        }
    }
    
    public enum ColorType: String, CaseIterable, Sendable {
        case cyan
        case magenta
        case yellow
        case black
    }
    
    public func makeThumb(configuration: LSliderConfiguration) -> some View {
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
        }
        .frame(width: sliderHeight, height: sliderHeight)
    }
    
    public func makeTrack(configuration: LSliderConfiguration) -> some View {
        return GeometryReader { geo in
            ZStack {
                AdaptiveLine(angle: configuration.angle)
                    .stroke(
                        LinearGradient(
                            gradient: Gradient(colors: colors),
                            startPoint: .leading,
                            endPoint: .trailing),
                        lineWidth: sliderHeight
                    )
                    .mask(Capsule())
                
                Capsule()
                    .stroke(Color.white)
                    .rotationEffect(configuration.angle)
            }
            .frame(width: geo.size.width + sliderHeight)
            .offset(x: -sliderHeight/2)
        }
    }
}

public struct CMYKColorPicker: View {
    @Binding public var color: ColorToken
    public var sliderHeights: CGFloat = 40
    
    public init(_ color: Binding<ColorToken>) {
        self._color = color
    }
    
    public init(_ color: Binding<ColorToken>, sliderHeights: CGFloat) {
        self._color = color
        self.sliderHeights = sliderHeights
    }
    
    private func makeSlider( _ colorType: CMYKSliderStyle.ColorType) -> some View {
        let value: Binding<Double> =  {
            switch colorType {
            case .cyan:
                return Binding(get: {color.cyan},
                               set: {color = color.update(cyan: $0)})
            case .magenta:
                return Binding(get: {color.magenta},
                               set: {color = color.update(magenta: $0)})
            case .yellow:
                return Binding(get: {color.yellow},
                               set: {color = color.update(yellow: $0)})
            case .black:
                return Binding(get: {color.keyBlack},
                               set: {color = color.update(keyBlack: $0)})
            }
        }()
        
        return LSlider(value)
            .linearSliderStyle(
                CMYKSliderStyle(sliderHeight: sliderHeights, type: colorType, color: color)
            )
            .frame(height: sliderHeights)
    }
    
    public var body: some View {
        VStack(spacing: 20){
            makeSlider( .cyan)
            makeSlider(.magenta)
            makeSlider(.yellow)
            makeSlider(.black)
        }
    }
}

