//
//  GradientPicker.swift
//  MyExamples
//
//  Created by Kieran Brown on 4/6/20.
//  Copyright © 2020 BrownandSons. All rights reserved.
//

import SwiftUI


// MARK: - Gradient Data



/// A Token representing the composite data from `LinearGradient`, `RadialGradient`, and `AngularGradient` parameters
@available(iOS 13.0, macOS 10.15, watchOS 6.0 , *)
public struct GradientData: Identifiable {
    /// A name used to uniquely identify this particular gradient data
    public var name: String
    
    /// Token representing the different types of SwiftUI Gradients
    public enum GradientType: String , CaseIterable, Identifiable {
        case linear
        case radial
        case angular
        
        public var id: String {self.rawValue}
    }
    /// The type of gradient (linear, radial, angular)
    public var type: GradientType = .linear
    /// Wrapper enum for `ColorRenderingMode`
    public enum ColorRenderMode: String, CaseIterable, Identifiable {
        case linear
        case extendedLinear
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
    /// The render mode to be used (linear, extendedLinear, nonlinear)
    public var renderMode: ColorRenderMode = .linear

    /// Gradient stops using a custom wrapper `UIColor` or `NSColor` wrapper
    /// depending on the systems requirements. Allows for easier modification of
    /// stop colors.
    public var stops: [(color: ColorToken, location:  CGFloat)]
    /// The currently selected stop if one is selected
    public var selected: UUID? = nil
    
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
        self.stops.map({.init(color: $0.0.color, location: $0.1)})
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
            file.append(" .init(color: Color(.sRGB, red: \(String(format: "%.3f", stop.color.red)), green: \(String(format: "%.3f", stop.color.green)), blue: \(String(format: "%.3f", stop.color.blue)), opacity: \(String(format: "%.3f", stop.color.alpha))), location: \(String(format: "%.3f", stop.location))),")
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
                     stops: [( ColorToken(r: 1, g: 0, b: 0),  0.3), (ColorToken(r: 0.8, g: 0.3, b: 0.3), 0.7)])
    }()
    
    public init(name: String, stops: [(ColorToken, CGFloat)]) {
        self.name = name
        self.stops = stops
    }
    
    
    public init(name: String, stops: [(ColorToken, CGFloat)], startPoint: UnitPoint, endPoint: UnitPoint) {
        self.name = name
        self.stops = stops
        self.start = startPoint
        self.end = endPoint
        self.type = .linear
    }
    public init(name: String, stops: [(ColorToken, CGFloat)], center: UnitPoint, startRadius: CGFloat, endRadius: CGFloat) {
        self.name = name
        self.stops = stops
        self.center = center
        self.startRadius = startRadius
        self.endRadius = endRadius
        self.type = .radial
    }
    public init(name: String, stops: [(ColorToken, CGFloat)], center: UnitPoint, startAngle: Double, endAngle: Double) {
        self.name = name
        self.stops = stops
        self.center = center
        self.startAngle = startAngle
        self.endAngle = endAngle
        self.type = .angular
    }
}
// MARK: Gradient Manager
@available(iOS 13.0, macOS 10.15, watchOS 6.0 , *)
public class GradientManager: ObservableObject {
    @Published public var gradient: GradientData
    @Published public var hideTools: Bool = false
    
    public func select(_ id: UUID) {
        if gradient.selected == id {
            gradient.selected = nil
        } else {
            gradient.selected = id
        }
    }
    
    public init(_ gradient: GradientData) {
        self.gradient = gradient
    }
}
@available(iOS 13.0, macOS 10.15, watchOS 6.0 , *)
public struct GradientPicker: View {
    @ObservedObject public var manager: GradientManager
    public init(_ manager: ObservedObject<GradientManager>) {
        self._manager = manager
    }
    
    private var toolToggle: some View {
        Toggle(isOn: $manager.hideTools,
               label: {Text(!self.manager.hideTools ? "Hide Tools" : "Show Tools")})
    }
    private var typePicker: some View {
        Picker("Gradient", selection: $manager.gradient.type) {
            ForEach(GradientData.GradientType.allCases, id: \.self) { (type) in
                Text(type.rawValue).tag(type)
            }
        }.pickerStyle(SegmentedPickerStyle())
    }
    private var renderModePicker: some View {
        Picker("Render Mode", selection: $manager.gradient.renderMode) {
            ForEach(GradientData.ColorRenderMode.allCases, id: \.self) { (type) in
                Text(type.rawValue).tag(type)
            }
        }.pickerStyle(SegmentedPickerStyle())
    }
    private var currentPicker: some View {
        Group {
            if manager.gradient.type == .linear {
                LinearGradientPicker()
            } else if manager.gradient.type == .radial {
                RadialGradientPicker()
            } else {
                AngularGradientPicker()
            }
        }.environmentObject(manager)
    }
    
    public var body: some View {
        VStack {
            typePicker
            renderModePicker
            toolToggle
            currentPicker
                .frame(idealHeight: 400, maxHeight: 500)
                .padding(35)
        }
    }
}


