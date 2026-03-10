// Swift toolchain version 6.0
// Running macOS version 26.3
// Created on 4/8/20.
//
// Author: Kieran Brown
//

import SwiftUI

public struct ColorToken: Identifiable, Sendable {
    public enum ColorFormulation: String, CaseIterable, Identifiable, Sendable {
        case rgb
        case hsb
        case cmyk
        case gray
        
        public var id: String {rawValue}
    }
    
    public enum RGBColorSpace: String, CaseIterable, Identifiable, Sendable {
        case displayP3
        case sRGB
        case sRGBLinear
        
        public var id: String {rawValue}
        
        public var space: Color.RGBColorSpace {
            switch self {
            case .displayP3: return .displayP3
            case .sRGB: return .sRGB
            case .sRGBLinear: return .sRGBLinear
            }
        }
    }
    
    public var colorFormulation: ColorFormulation
    public var rgbColorSpace: RGBColorSpace = .sRGB
    
    public var name: String = "New"
    public let id: UUID
    public let dateCreated: Date
    
    public var white: Double = 0.5
    
    public var red: Double = 0.5
    public var green: Double = 0.5
    public var blue: Double = 0.5
    
    public var hue: Double = 0.5
    public var saturation: Double = 0.5
    public var brightness: Double = 0.5
    
    public var cyan: Double = 0.5
    public var magenta: Double = 0.5
    public var yellow: Double = 0.5
    public var keyBlack: Double = 0.5
    
    public var alpha: Double = 1
    
    public var hex: String { color.description }
    
    public var color: Color {
        switch colorFormulation {
        case .rgb:
            return Color(rgbColorSpace.space, red: red, green: green, blue: blue, opacity: alpha)
        case .hsb:
            return Color(hue: hue, saturation: saturation, brightness: brightness, opacity: alpha)
        case .cmyk:
            return Color(
                PlatformColor(cmyk: (CGFloat(cyan), CGFloat(magenta), CGFloat(yellow), CGFloat(keyBlack)))
            )
                .opacity(alpha)
        case .gray:
            return Color(white: white).opacity(alpha)
        }
    }
    
    public var fileFormat: String {
        switch colorFormulation {
        case .rgb:
            return "Color(.\(rgbColorSpace.space), red: \(red), green: \(green), blue: \(blue), opacity: \(alpha))"
        case .hsb:
            return "Color(hue: \(hue), saturation: \(saturation), brightness: \(brightness), opacity: \(alpha))"
        case .cmyk:
            return "Color(PlatformColor(cmyk: (\(cyan), \(magenta), \(yellow), \(keyBlack)))).opacity(\(alpha))"
        case .gray:
            return "Color(white: \(white).opacity(\(alpha))"
        }
    }
    
    internal init(id: UUID,
                  date: Date,
                  name: String,
                  formulation: ColorFormulation,
                  rgbColorSpace: RGBColorSpace,
                  white: Double,
                  red: Double,
                  green: Double,
                  blue: Double,
                  hue: Double,
                  saturation: Double,
                  brightness: Double,
                  cyan: Double,
                  magenta: Double,
                  yellow: Double,
                  keyBlack: Double,
                  alpha: Double) {
        self.id = id
        self.dateCreated = date
        self.name = name
        self.colorFormulation = formulation
        self.rgbColorSpace = rgbColorSpace
        self.white = white
        self.red = red
        self.green = green
        self.blue = blue
        self.hue = hue
        self.saturation = saturation
        self.brightness = brightness
        self.cyan = cyan
        self.magenta = magenta
        self.yellow = yellow
        self.keyBlack = keyBlack
        self.alpha = alpha
        
    }
    
    public func update() -> ColorToken {
        ColorToken(id: id,
              date: dateCreated,
              name: name,
              formulation: colorFormulation,
              rgbColorSpace: rgbColorSpace,
              white: white,
              red: red,
              green: green,
              blue: blue,
              hue: hue,
              saturation: saturation,
              brightness: brightness,
              cyan: cyan,
              magenta: magenta,
              yellow: yellow,
              keyBlack: keyBlack,
              alpha: alpha)
    }
    
    public mutating func update(white: Double)  -> ColorToken {
        self.white = white
        colorFormulation = .gray
        return update()
    }
    
    public mutating func update(red: Double) -> ColorToken {
        self.red = red
        colorFormulation = .rgb
        return update()
    }
    
    public mutating func update(green: Double) -> ColorToken {
        self.green = green
        colorFormulation = .rgb
        return update()
    }
    
    public mutating func update(blue: Double) -> ColorToken {
        self.blue = blue
        colorFormulation = .rgb
        return update()
    }
    
    public mutating func update(hue: Double) -> ColorToken {
        self.hue = hue
        colorFormulation = .hsb
        return update()
    }
    
    public mutating func update(saturation: Double) -> ColorToken {
        self.saturation = saturation
        colorFormulation = .hsb
        return update()
    }
    
    public mutating func update(brightness: Double) -> ColorToken {
        self.brightness = brightness
        colorFormulation = .hsb
        return update()
    }
    
    public mutating func update(cyan: Double) -> ColorToken {
        self.cyan = cyan
        colorFormulation = .cmyk
        return update()
    }
    
    public mutating func update(magenta: Double) -> ColorToken {
        self.magenta = magenta
        colorFormulation = .cmyk
        return update()
    }
    
    public mutating func update(yellow: Double) -> ColorToken {
        self.yellow = yellow
        colorFormulation = .cmyk
        return update()
    }
    
    public mutating func update(keyBlack: Double) -> ColorToken {
        self.keyBlack = keyBlack
        colorFormulation = .cmyk
        return update()
    }
    
    public mutating func update(alpha: Double) -> ColorToken {
        self.alpha = alpha
        return update()
    }
    
    // MARK: RGB Inits
    public init(r: Double, g: Double, b: Double) {
        self.id = .init()
        self.dateCreated = .init()
        self.red = r
        self.green = g
        self.blue = b
        self.colorFormulation = .rgb
    }
    public init(name: String, r: Double, g: Double, b: Double) {
        self.name = name
        self.id = .init()
        self.dateCreated = .init()
        self.red = r
        self.green = g
        self.blue = b
        self.colorFormulation = .rgb
    }
    public init(colorSpace: RGBColorSpace, r: Double, g: Double, b: Double) {
        self.id = .init()
        self.dateCreated = .init()
        self.red = r
        self.green = g
        self.blue = b
        self.colorFormulation = .rgb
        self.rgbColorSpace = colorSpace
        
    }
    
    public init(name: String, colorSpace: RGBColorSpace, r: Double, g: Double, b: Double) {
        self.name = name
        self.id = .init()
        self.dateCreated = .init()
        self.red = r
        self.green = g
        self.blue = b
        self.colorFormulation = .rgb
        self.rgbColorSpace = colorSpace
        
    }
    
    public init(r: Double, g: Double, b: Double, a: Double) {
        self.id = .init()
        self.dateCreated = .init()
        self.red = r
        self.green = g
        self.blue = b
        self.alpha = a
        self.colorFormulation = .rgb
    }
    
    public init(name: String, r: Double, g: Double, b: Double, a: Double) {
        self.name = name
        self.id = .init()
        self.dateCreated = .init()
        self.red = r
        self.green = g
        self.blue = b
        self.alpha = a
        self.colorFormulation = .rgb
    }
    
    public init(colorSpace: RGBColorSpace, r: Double, g: Double, b: Double, a: Double) {
        self.id = .init()
        self.dateCreated = .init()
        self.red = r
        self.green = g
        self.blue = b
        self.alpha = a
        self.colorFormulation = .rgb
        self.rgbColorSpace = colorSpace
    }
    
    public init(name: String, colorSpace: RGBColorSpace, r: Double, g: Double, b: Double, a: Double) {
        self.name = name
        self.id = .init()
        self.dateCreated = .init()
        self.red = r
        self.green = g
        self.blue = b
        self.alpha = a
        self.colorFormulation = .rgb
        self.rgbColorSpace = colorSpace
    }
    
    // MARK: HSB Inits
    public init(hue: Double, saturation: Double, brightness: Double) {
        self.id = .init()
        self.dateCreated = .init()
        self.hue = hue
        self.saturation = saturation
        self.brightness = brightness
        self.colorFormulation = .hsb
    }
    
    public init(name: String, hue: Double, saturation: Double, brightness: Double) {
        self.id = .init()
        self.dateCreated = .init()
        self.name = name
        self.hue = hue
        self.saturation = saturation
        self.brightness = brightness
        self.colorFormulation = .hsb
    }
    
    public init(hue: Double, saturation: Double, brightness: Double, opacity: Double) {
        self.id = .init()
        self.dateCreated = .init()
        self.hue = hue
        self.saturation = saturation
        self.brightness = brightness
        self.alpha = opacity
        self.colorFormulation = .hsb
    }
    
    public init(name: String, hue: Double, saturation: Double, brightness: Double, opacity: Double) {
        self.id = .init()
        self.dateCreated = .init()
        self.name = name
        self.hue = hue
        self.saturation = saturation
        self.brightness = brightness
        self.alpha = opacity
        self.colorFormulation = .hsb
    }
    
    // MARK: CMYK Inits
    public init(cyan: Double, magenta: Double, yellow: Double, keyBlack: Double) {
        self.id = .init()
        self.dateCreated = .init()
        self.cyan = cyan
        self.magenta = magenta
        self.yellow = yellow
        self.keyBlack = keyBlack
        self.colorFormulation = .cmyk
    }
    
    public init(name: String, cyan: Double, magenta: Double, yellow: Double, keyBlack: Double) {
        self.id = .init()
        self.dateCreated = .init()
        self.name = name
        self.cyan = cyan
        self.magenta = magenta
        self.yellow = yellow
        self.keyBlack = keyBlack
        self.colorFormulation = .cmyk
    }
    
    // MARK: White Inits
    public init(white: Double) {
        self.id = .init()
        self.dateCreated = .init()
        self.white = white
        self.colorFormulation = .gray
    }
    
    public init(name: String, white: Double) {
        self.id = .init()
        self.dateCreated = .init()
        self.name = name
        self.white = white
        self.colorFormulation = .gray
    }
    
    public init(white: Double, opacity: Double) {
        self.id = .init()
        self.dateCreated = .init()
        self.white = white
        self.alpha = opacity
        self.colorFormulation = .gray
    }
    
    public init(name: String, white: Double, opacity: Double) {
        self.id = .init()
        self.dateCreated = .init()
        self.name = name
        self.white = white
        self.alpha = opacity
        self.colorFormulation = .gray
    }
    
    public init(_ token: ColorToken) {
        self.id = .init()
        self.dateCreated = .init()
        self.name = token.name
        self.alpha = token.alpha
        self.white = token.white
        self.rgbColorSpace = token.rgbColorSpace
        self.colorFormulation = token.colorFormulation
        self.red = token.red
        self.green = token.green
        self.blue = token.blue
        self.hue = token.hue
        self.saturation = token.saturation
        self.brightness = token.brightness
        self.cyan = token.cyan
        self.magenta = token.magenta
        self.yellow = token.yellow
        self.keyBlack = token.keyBlack
    }
}

public extension ColorToken {
    
    // MARK: - Color Scheme
    enum ColorScheme: String, CaseIterable {
        case analagous
        case monochromatic = "mono"
        case triad
        case complementary = "complement"
    }
    
    func colorScheme(_ type: ColorScheme) -> [ColorToken] {
        switch (type) {
        case .analagous:
            return analgousColors()
        case .monochromatic:
            return monochromaticColors()
        case .triad:
            return triadColors()
        default:
            return complementaryColors()
        }
    }
    
    func analgousColors() -> [ColorToken] {
        return [
            ColorToken(hue: (hue*360+30)/360, saturation: saturation-0.05, brightness: brightness-0.1, opacity: alpha),
                ColorToken(hue: (hue*360+15)/360, saturation: saturation-0.05, brightness: brightness-0.05, opacity: alpha),
                ColorToken(hue: (hue*360-15)/360, saturation: saturation-0.05, brightness: brightness-0.05, opacity: alpha),
                ColorToken(hue: (hue*360-30)/360, saturation: saturation-0.05, brightness: brightness-0.1, opacity: alpha)
        ]
    }
    
    func monochromaticColors() -> [ColorToken] {
        return [
            ColorToken(hue: hue, saturation: saturation/2, brightness: brightness/3, opacity: alpha),
                ColorToken(hue: hue, saturation: saturation, brightness: brightness/2, opacity: alpha),
                ColorToken(hue: hue, saturation: saturation/3, brightness: 2*brightness/3, opacity: alpha),
                ColorToken(hue: hue, saturation: saturation, brightness: 4*brightness/5, opacity: alpha)
        ]
        
    }
    
    func triadColors() -> [ColorToken] {
        return [
            ColorToken(hue: (120+hue*360)/360, saturation: 2*saturation/3, brightness: brightness-0.05, opacity: alpha),
                ColorToken(hue: (120+hue*360)/360, saturation: saturation, brightness: brightness, opacity: alpha),
                ColorToken(hue: (240+hue*360)/360, saturation: saturation, brightness: brightness, opacity: alpha),
                ColorToken(hue: (240+hue*360)/360, saturation: 2*saturation/3, brightness: brightness-0.05, opacity: alpha)
        ]
    }
    
    func complementaryColors() -> [ColorToken] {
        return [
            ColorToken(hue: hue, saturation: saturation, brightness: 4*brightness/5, opacity: alpha),
                 ColorToken(hue: hue, saturation: 5*saturation/7, brightness: brightness, opacity: alpha),
                 ColorToken(hue: (180+hue*360)/360, saturation: saturation, brightness: brightness, opacity: alpha),
                 ColorToken(hue: (180+hue*360)/360, saturation: 5*saturation/7, brightness: brightness, opacity: alpha)
        ]
    }
}
