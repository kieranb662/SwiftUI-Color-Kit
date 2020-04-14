//
//  GradientData.swift
//  
//
//  Created by Kieran Brown on 4/13/20.
//


import SwiftUI


/// A Token representing the composite data from `LinearGradient`, `RadialGradient`, and `AngularGradient` parameters
/// When finished designing the gradient just access the `swiftUIFile` value and copy/paste it into your project. 
@available(iOS 13.0, macOS 10.15, watchOS 6.0 , *)
public struct GradientData: Identifiable {
    
    /// Token representing the different types of SwiftUI Gradients
    public enum GradientType: String , CaseIterable, Identifiable {
        case linear
        case radial
        case angular
        
        public var id: String {self.rawValue}
    }
    
    /// Wrapper enum for `ColorRenderingMode`
    public enum ColorRenderMode: String, CaseIterable, Identifiable {
        case linear
        case extendedLinear = "extended"
        case nonLinear
        
        public var id: String { self.rawValue }
        
        public var renderingMode: ColorRenderingMode {
            switch self {
            case .linear:         return .linear
            case .extendedLinear: return .extendedLinear
            case .nonLinear:      return .linear
            }
        }
    }
    public struct Stop: Identifiable {
        public var color: ColorToken
        public var location: CGFloat
        
        public var id: UUID { color.id }
        
        public init(color: ColorToken, location: CGFloat) {
            self.color = color
            self.location = location
        }
        
        public var gradientStop: Gradient.Stop {
            return .init(color: color.color, location: location)
        }
    }
    
    /// A name used to uniquely identify this particular gradient data
    public var name: String
    /// The type of gradient (linear, radial, angular)
    public var type: GradientType = .linear
    /// The render mode to be used (linear, extendedLinear, nonlinear)
    public var renderMode: ColorRenderMode = .linear

    /// Gradient stops using a custom wrapper `UIColor` or `NSColor` wrapper
    /// depending on the systems requirements. Allows for easier modification of
    /// stop colors.
    public var stops: [Stop]
    
    
    // Linear
    /// `LinearGradient` Start Location
    public var start: UnitPoint = .leading
    /// `LinearGradient` End Location
    public var end: UnitPoint = .trailing
    // Radial
    /// `RadialGradient` Start Radius
    var startRadius: CGFloat = 0
    /// `RadialGradient` End Radius
    public var endRadius: CGFloat = 200
    /// `Radial Gradient` or `Angular Gradient` center
    public var center: UnitPoint = .center
    // Angular
    /// `AngularGradient` Start Angle
    public var startAngle: Double = 0
    /// `AngularGradient` End Angle
    public var endAngle: Double = 0.5
 
    public var _stops: [Gradient.Stop] {
        self.stops
            .map({$0.gradientStop})
            .sorted(by: {$0.location < $1.location})
    }
    public var gradient: Gradient {
        Gradient(stops: _stops)
    }
    public var id: String {name}
    // MARK: Gradient To File
    /// Creates a `Gradient` to be copied and pasted into a SwiftUI project
    public var gradientFile: String {
        var file: String = "Gradient(stops: ["
        for stop in stops.sorted(by: {$0.location < $1.location}) {
            file.append(" .init(color: \(stop.color.fileFormat), location: \(String(format: "%.3f", stop.location))),")
        }
        
        return file.dropLast() + "])"
    }
    /// Creates a string representing the current gradient data to be copy and pasted into a SwiftUI project
    public var swiftUIFile: String {
        switch type {
        case .linear:
            return "let <#Name#> = LinearGradient(gradient: \(gradientFile), startPoint: UnitPoint(x: \(String(format: "%.3f", start.x)), y: \(String(format: "%.3f", start.y))), endPoint: UnitPoint(x: \(String(format: "%.3f", end.x)), y: \(String(format: "%.3f", end.y))))"
        case .radial:
            return "let <#Name#> = RadialGradient(gradient: \(gradientFile), center: UnitPoint(x: \(String(format: "%.3f", center.x)), y: \(String(format: "%.3f", center.y))), startRadius: \(String(format: "%.3f", startRadius)), endRadius: \(String(format: "%.3f", endRadius)))"
        case .angular:
            return "let <#Name#> = AngularGradient(gradient: \(gradientFile), center: UnitPoint(x: \(String(format: "%.3f", center.x)), y: \(String(format: "%.3f", center.y))), startAngle: Angle(radians: \(String(format: "%.3f", startAngle))), endAngle: Angle(radians: \(String(format: "%.3f", startAngle > endAngle ? endAngle + 2 * .pi : endAngle))))"
        }
    }
    /// A Convienient default value
    public static let defaultValue: GradientData = {
        GradientData(name: "name",
                     stops: [.init(color: ColorToken(colorSpace: .sRGB, r: 252/255, g: 70/255, b: 107/255, a: 1), location: 0),
                             .init(color: ColorToken(colorSpace: .sRGB, r: 63/255, g: 94/255, b: 251/255, a: 1), location: 1)])
    }()
    
    public init(name: String, stops: [Stop]) {
        self.name = name
        self.stops = stops
    }
    
    
    public init(name: String, stops: [Stop], startPoint: UnitPoint, endPoint: UnitPoint) {
        self.name = name
        self.stops = stops
        self.start = startPoint
        self.end = endPoint
        self.type = .linear
    }
    public init(name: String, stops: [Stop], center: UnitPoint, startRadius: CGFloat, endRadius: CGFloat) {
        self.name = name
        self.stops = stops
        self.center = center
        self.startRadius = startRadius
        self.endRadius = endRadius
        self.type = .radial
    }
    public init(name: String, stops: [Stop], center: UnitPoint, startAngle: Double, endAngle: Double) {
        self.name = name
        self.stops = stops
        self.center = center
        self.startAngle = startAngle
        self.endAngle = endAngle
        self.type = .angular
    }
}
