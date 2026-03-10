// Swift toolchain version 6.0
// Running macOS version 26.3
// Created on 4/6/20.
//
// Author: Kieran Brown
//

import SwiftUI

// MARK: - Configuration Structures

/// Used to style the dragging view that represents a gradients start or end value
public struct GradientHandleConfiguration {
    public let isActive: Bool
    public let isDragging: Bool
    public let isHidden: Bool
    public let angle: Angle
    public init(_ isActive: Bool, _ isDragging: Bool, _ isHidden: Bool, _ angle: Angle) {
        self.isActive = isActive
        self.isDragging = isDragging
        self.isHidden = isHidden
        self.angle = angle
    }
}

/// Used to style a view representing a single stop in a gradient
public struct GradientStopConfiguration {
    public let isActive: Bool
    public let isSelected: Bool
    public let isHidden: Bool
    public let color: Color
    public let angle: Angle
    
    public init(_ isActive: Bool, _ isSelected: Bool, _ isHidden: Bool, _ color: Color, _ angle: Angle) {
        self.isActive = isActive
        self.isSelected = isSelected
        self.isHidden = isHidden
        self.color = color
        self.angle = angle
    }
}

/// Used to style the draggable view representing the center of either an Angular or Radial Gradient
public struct GradientCenterConfiguration {
    public let isActive: Bool
    public let isHidden: Bool
}

/// Used to style the slider bar the stops overlay in the `RadialGradientPicker`
public struct RadialGradientBarConfiguration {
    public let gradient: Gradient
    public let isHidden: Bool
}

// MARK: -  Default Styles

public struct DefaultLinearGradientPickerStyle: LinearGradientPickerStyle {
    public init() {}
    public func makeGradient(gradient: LinearGradient) -> some View {
        RoundedRectangle(cornerRadius: 5)
            .fill(gradient)
            .overlay(RoundedRectangle(cornerRadius: 5).stroke(Color.white))
    }
    public func makeStartHandle(configuration: GradientHandleConfiguration) -> some View {
        Capsule()
            .foregroundColor(Color.white)
            .frame(width: 25, height: 75)
            .rotationEffect(configuration.angle + Angle(degrees: 90))
            .shadow(radius: 3)
            .opacity(configuration.isHidden ? 0 : 1)
    }
    public func makeEndHandle(configuration: GradientHandleConfiguration) -> some View {
        Capsule()
            .foregroundColor(Color.white)
            .frame(width: 25, height: 75)
            .rotationEffect(configuration.angle + Angle(degrees: 90))
            .shadow(radius: 3)
            .opacity(configuration.isHidden ? 0 : 1)
    }
    public func makeStop(configuration: GradientStopConfiguration) -> some View {
        Capsule()
            .foregroundColor(configuration.color)
            .frame(width: 20, height: 55)
            .overlay(Capsule().stroke( configuration.isSelected ? Color.yellow : Color.white ))
            .rotationEffect(configuration.angle + Angle(degrees: 90))
            .shadow(color: configuration.isSelected ? Color.white : Color.black, radius: 3)
            .opacity(configuration.isHidden ? 0 : 1)
        
    }
}

public struct DefaultRadialGradientPickerStyle: RadialGradientPickerStyle {
    public init() {}
    public func makeGradient(gradient: RadialGradient) -> some View {
        RoundedRectangle(cornerRadius: 5)
            .fill(gradient)
            .overlay(RoundedRectangle(cornerRadius: 5).stroke(Color.white))
    }
    public func makeCenter(configuration: GradientCenterConfiguration) -> some View {
        Circle()
            .fill(configuration.isActive ? Color.yellow : Color.white)
            .frame(width: 35, height: 35)
            .opacity(configuration.isHidden ? 0 : 1)
    }
    public func makeStartHandle(configuration: GradientHandleConfiguration) -> some View {
        Circle()
            .stroke(Color.white.opacity(0.001), style: StrokeStyle(lineWidth: 10))
            .overlay(Circle().stroke(Color.black, style: StrokeStyle(lineWidth: 1, dash: [10, 5])))
            .opacity(configuration.isHidden ? 0 : 1)
    }
    public func makeEndHandle(configuration: GradientHandleConfiguration) -> some View {
        Circle()
            .stroke(Color.white.opacity(0.001), style: StrokeStyle(lineWidth: 10))
            .overlay(Circle().stroke(Color.white, style: StrokeStyle(lineWidth: 1, dash: [10, 5])))
            .opacity(configuration.isHidden ? 0 : 1)
    }
    public func makeStop(configuration: GradientStopConfiguration) -> some View {
        Group {
            if !configuration.isHidden {
                RoundedRectangle(cornerRadius: 5)
                    .foregroundColor(configuration.color)
                    .frame(width: 25, height: 45)
                    .overlay(RoundedRectangle(cornerRadius: 5).stroke( configuration.isSelected ? Color.yellow : Color.white ))
                    .shadow(color: configuration.isSelected ? Color.white : Color.black, radius: 3)
                    .transition(AnyTransition.opacity)
 
            }
        }
    }
    public func makeBar(configuration: RadialGradientBarConfiguration) -> some View {
        Group {
            if !configuration.isHidden {
                RoundedRectangle(cornerRadius: 5)
                    .fill(LinearGradient(gradient: configuration.gradient, startPoint: .leading, endPoint: .trailing))
                    .overlay(RoundedRectangle(cornerRadius: 5).stroke(Color.white))
                    .transition(AnyTransition.move(edge: .leading))
            }
        }
    }
}

public struct DefaultAngularGradientPickerStyle: AngularGradientPickerStyle, Sendable {
    public init() {}
    public func makeGradient(gradient: AngularGradient) -> some View {
        RoundedRectangle(cornerRadius: 5)
            .fill(gradient)
            .overlay(RoundedRectangle(cornerRadius: 5).stroke(Color.white))
    }
    public func makeCenter(configuration: GradientCenterConfiguration) -> some View {
        Circle()
            .fill(configuration.isActive ? Color.yellow : Color.white)
            .frame(width: 35, height: 35)
            .opacity(configuration.isHidden ? 0 : 1)
    }
    public func makeStartHandle(configuration: GradientHandleConfiguration) -> some View {
        Capsule()
            .foregroundColor(Color.white)
            .frame(width: 30, height: 75)
            .rotationEffect(configuration.angle)
            .shadow(radius: 3)
            .opacity(configuration.isHidden ? 0 : 1)
    }
    public func makeEndHandle(configuration: GradientHandleConfiguration) -> some View {
        Capsule()
            .foregroundColor(Color.white)
            .frame(width: 30, height: 75)
            .rotationEffect(configuration.angle)
            .shadow(radius: 3)
            .opacity(configuration.isHidden ? 0 : 1)
    }
    public func makeStop(configuration: GradientStopConfiguration) -> some View {
        Group {
            if !configuration.isHidden {
                Circle()
                    .foregroundColor(configuration.color)
                    .frame(width: 25, height: 45)
                    .overlay(Circle().stroke( configuration.isSelected ? Color.yellow : Color.white ))
                    .shadow(color: configuration.isSelected ? Color.white : Color.black, radius: 3)
                    .transition(AnyTransition.opacity)
            }
        }
    }
}

// MARK: - Style Setup

// MARK: Linear

public protocol LinearGradientPickerStyle: Sendable {
    associatedtype GradientView: View
    associatedtype StartHandle: View
    associatedtype EndHandle: View
    associatedtype Stop: View
    
    func makeGradient(gradient: LinearGradient) -> Self.GradientView
    func makeStartHandle(configuration: GradientHandleConfiguration) -> Self.StartHandle
    func makeEndHandle(configuration: GradientHandleConfiguration) -> Self.EndHandle
    func makeStop(configuration: GradientStopConfiguration) -> Self.Stop
}

public extension LinearGradientPickerStyle {
    func makeGradientTypeErased(gradient: LinearGradient) -> AnyView {
        AnyView(makeGradient(gradient: gradient))
    }
    func makeStartHandleTypeErased(configuration: GradientHandleConfiguration) -> AnyView {
        AnyView(makeStartHandle(configuration: configuration))
    }
    func makeEndHandleTypeErased(configuration: GradientHandleConfiguration) -> AnyView {
        AnyView(makeEndHandle(configuration: configuration))
    }
    func makeStopTypeErased(configuration: GradientStopConfiguration) -> AnyView {
        AnyView(makeStop(configuration: configuration))
    }
}

public struct AnyLinearGradientPickerStyle: LinearGradientPickerStyle, Sendable {
    private let _makeGradient: @Sendable (LinearGradient) -> AnyView
    public func makeGradient(gradient: LinearGradient) -> some View {
        return _makeGradient(gradient)
    }
    
    private let _makeStartHandle: @Sendable (GradientHandleConfiguration) -> AnyView
    public func makeStartHandle(configuration: GradientHandleConfiguration) -> some View {
        return _makeStartHandle(configuration)
    }
    
    private let _makeEndHandle: @Sendable (GradientHandleConfiguration) -> AnyView
    public func makeEndHandle(configuration: GradientHandleConfiguration) -> some View {
        return _makeEndHandle(configuration)
    }
    
    private let _makeStop: @Sendable (GradientStopConfiguration) -> AnyView
    public func makeStop(configuration: GradientStopConfiguration) -> some View {
        return _makeStop(configuration)
    }
    
    public init<ST: LinearGradientPickerStyle>(_ style: ST) {
        _makeGradient = style.makeGradientTypeErased
        _makeStartHandle = style.makeStartHandleTypeErased
        _makeEndHandle = style.makeEndHandleTypeErased
        _makeStop = style.makeStopTypeErased
    }
}

public struct LinearGradientPickerStyleKey: EnvironmentKey {
    public static let defaultValue: AnyLinearGradientPickerStyle  = AnyLinearGradientPickerStyle(DefaultLinearGradientPickerStyle())
}

extension EnvironmentValues {
    public var linearGradientPickerStyle: AnyLinearGradientPickerStyle {
        get {
            return self[LinearGradientPickerStyleKey.self]
        }
        set {
            self[LinearGradientPickerStyleKey.self] = newValue
        }
    }
}

extension View {
    public func linearGradientPickerStyle<S>(_ style: S) -> some View where S: LinearGradientPickerStyle {
        environment(\.linearGradientPickerStyle, AnyLinearGradientPickerStyle(style))
    }
}

// MARK:  Radial

public protocol RadialGradientPickerStyle: Sendable {
    associatedtype GradientView: View
    associatedtype Center: View
    associatedtype StartHandle: View
    associatedtype EndHandle: View
    associatedtype Stop: View
    associatedtype GradientBar: View
    
    func makeGradient(gradient: RadialGradient) -> Self.GradientView
    func makeCenter(configuration: GradientCenterConfiguration) -> Self.Center
    func makeStartHandle(configuration: GradientHandleConfiguration) -> Self.StartHandle
    func makeEndHandle(configuration: GradientHandleConfiguration) -> Self.EndHandle
    func makeStop(configuration: GradientStopConfiguration) -> Self.Stop
    func makeBar(configuration: RadialGradientBarConfiguration) -> Self.GradientBar
    
}

public extension RadialGradientPickerStyle {
    func makeGradientTypeErased(gradient: RadialGradient) -> AnyView {
        AnyView(makeGradient(gradient: gradient))
    }
    
    func makeCenterTypeErased(configuration: GradientCenterConfiguration) -> AnyView {
        AnyView(makeCenter(configuration: configuration))
    }
    
    func makeStartHandleTypeErased(configuration: GradientHandleConfiguration) -> AnyView {
        AnyView(makeStartHandle(configuration: configuration))
    }
    
    func makeEndHandleTypeErased(configuration: GradientHandleConfiguration) -> AnyView {
        AnyView(makeEndHandle(configuration: configuration))
    }
    
    func makeStopTypeErased(configuration: GradientStopConfiguration) -> AnyView {
        AnyView(makeStop(configuration: configuration))
    }
    
    func makeBarTypeErased(configuration: RadialGradientBarConfiguration) -> AnyView {
        AnyView(makeBar(configuration: configuration))
    }
}

public struct AnyRadialGradientPickerStyle: RadialGradientPickerStyle, Sendable {
    private let _makeGradient: @Sendable (RadialGradient) -> AnyView
    public func makeGradient(gradient: RadialGradient) -> some View {
        return _makeGradient(gradient)
    }
    
    private let _makeCenter: @Sendable (GradientCenterConfiguration) -> AnyView
    public func makeCenter(configuration: GradientCenterConfiguration) -> some View {
        return _makeCenter(configuration)
    }
    
    private let _makeStartHandle: @Sendable (GradientHandleConfiguration) -> AnyView
    public func makeStartHandle(configuration: GradientHandleConfiguration) -> some View {
        return _makeStartHandle(configuration)
    }
    
    private let _makeEndHandle: @Sendable (GradientHandleConfiguration) -> AnyView
    public func makeEndHandle(configuration: GradientHandleConfiguration) -> some View {
        return _makeEndHandle(configuration)
    }
    
    private let _makeStop: @Sendable (GradientStopConfiguration) -> AnyView
    public func makeStop(configuration: GradientStopConfiguration) -> some View {
        return _makeStop(configuration)
    }
    
    private let _makeBar: @Sendable (RadialGradientBarConfiguration) -> AnyView
    public func makeBar(configuration: RadialGradientBarConfiguration) -> some View {
        return _makeBar(configuration)
    }
    
    public init<ST: RadialGradientPickerStyle>(_ style: ST) {
        _makeGradient = style.makeGradientTypeErased
        _makeCenter = style.makeCenterTypeErased
        _makeStartHandle = style.makeStartHandleTypeErased
        _makeEndHandle = style.makeEndHandleTypeErased
        _makeStop = style.makeStopTypeErased
        _makeBar = style.makeBarTypeErased
    }
}

public struct RadialGradientPickerStyleKey: EnvironmentKey {
    public static let defaultValue: AnyRadialGradientPickerStyle  = AnyRadialGradientPickerStyle(DefaultRadialGradientPickerStyle())
}

extension EnvironmentValues {
    public var radialGradientPickerStyle: AnyRadialGradientPickerStyle {
        get {
            return self[RadialGradientPickerStyleKey.self]
        }
        set {
            self[RadialGradientPickerStyleKey.self] = newValue
        }
    }
}

extension View {
    public func radialGradientPickerStyle<S>(_ style: S) -> some View where S: RadialGradientPickerStyle {
        environment(\.radialGradientPickerStyle, AnyRadialGradientPickerStyle(style))
    }
}

// MARK:  Angular

public protocol AngularGradientPickerStyle: Sendable {
    associatedtype GradientView: View
    associatedtype Center: View
    associatedtype StartHandle: View
    associatedtype EndHandle: View
    associatedtype Stop: View
    
    func makeGradient(gradient: AngularGradient) -> Self.GradientView
    func makeCenter(configuration: GradientCenterConfiguration) -> Self.Center
    func makeStartHandle(configuration: GradientHandleConfiguration) -> Self.StartHandle
    func makeEndHandle(configuration: GradientHandleConfiguration) -> Self.EndHandle
    func makeStop(configuration: GradientStopConfiguration) -> Self.Stop
    
}

public extension AngularGradientPickerStyle {
    func makeGradientTypeErased(gradient: AngularGradient) -> AnyView {
        AnyView(makeGradient(gradient: gradient))
    }
    
    func makeCenterTypeErased(configuration: GradientCenterConfiguration) -> AnyView {
        AnyView(makeCenter(configuration: configuration))
    }
    
    func makeStartHandleTypeErased(configuration: GradientHandleConfiguration) -> AnyView {
        AnyView(makeStartHandle(configuration: configuration))
    }
    
    func makeEndHandleTypeErased(configuration: GradientHandleConfiguration) -> AnyView {
        AnyView(makeEndHandle(configuration: configuration))
    }
    
    func makeStopTypeErased(configuration: GradientStopConfiguration) -> AnyView {
        AnyView(makeStop(configuration: configuration))
    }
}

public struct AnyAngularGradientPickerStyle: AngularGradientPickerStyle, Sendable {
    private let _makeGradient: @Sendable (AngularGradient) -> AnyView
    public func makeGradient(gradient: AngularGradient) -> some View {
        return _makeGradient(gradient)
    }
    
    private let _makeCenter: @Sendable (GradientCenterConfiguration) -> AnyView
    public func makeCenter(configuration: GradientCenterConfiguration) -> some View {
        return _makeCenter(configuration)
    }
    
    private let _makeStartHandle: @Sendable (GradientHandleConfiguration) -> AnyView
    public func makeStartHandle(configuration: GradientHandleConfiguration) -> some View {
        return _makeStartHandle(configuration)
    }
    
    private let _makeEndHandle: @Sendable (GradientHandleConfiguration) -> AnyView
    public func makeEndHandle(configuration: GradientHandleConfiguration) -> some View {
        return _makeEndHandle(configuration)
    }
    
    private let _makeStop: @Sendable (GradientStopConfiguration) -> AnyView
    public func makeStop(configuration: GradientStopConfiguration) -> some View {
        return _makeStop(configuration)
    }
    
    public init<ST: AngularGradientPickerStyle>(_ style: ST) {
        _makeGradient = style.makeGradientTypeErased
        _makeCenter = style.makeCenterTypeErased
        _makeStartHandle = style.makeStartHandleTypeErased
        _makeEndHandle = style.makeEndHandleTypeErased
        _makeStop = style.makeStopTypeErased
        
    }
}

public struct AngularGradientPickerStyleKey: EnvironmentKey {
    public static let defaultValue: AnyAngularGradientPickerStyle  = AnyAngularGradientPickerStyle(DefaultAngularGradientPickerStyle())
}

extension EnvironmentValues {
    public var angularGradientPickerStyle: AnyAngularGradientPickerStyle {
        get {
            return self[AngularGradientPickerStyleKey.self]
        }
        set {
            self[AngularGradientPickerStyleKey.self] = newValue
        }
    }
}

extension View {
    public func angularGradientPickerStyle<S>(_ style: S) -> some View where S: AngularGradientPickerStyle {
        environment(\.angularGradientPickerStyle, AnyAngularGradientPickerStyle(style))
    }
}
