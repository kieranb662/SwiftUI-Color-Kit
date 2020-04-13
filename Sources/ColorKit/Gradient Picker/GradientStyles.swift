//
//  GradientStyles.swift
//  MyExamples
//
//  Created by Kieran Brown on 4/6/20.
//  Copyright © 2020 BrownandSons. All rights reserved.
//

import SwiftUI
// MARK: - Configuration Structures


/// Used to style the dragging view that represents a gradients start or end value
@available(iOS 13.0, macOS 10.15, watchOS 6.0 , *)
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
@available(iOS 13.0, macOS 10.15, watchOS 6.0 , *)
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
@available(iOS 13.0, macOS 10.15, watchOS 6.0 , *)
public struct GradientCenterConfiguration {
    public let isActive: Bool
    public let isHidden: Bool
}
/// Used to style the slider bar the stops overlay in the `RadialGradientPicker`
@available(iOS 13.0, macOS 10.15, watchOS 6.0 , *)
public struct RadialGradientBarConfiguration {
    public let gradient: Gradient
    public let isHidden: Bool
}

// MARK: -  Default Styles
@available(iOS 13.0, macOS 10.15, watchOS 6.0 , *)
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
            .animation(.none)
            .shadow(radius: 3)
            .opacity(configuration.isHidden ? 0 : 1)
    }
    public func makeEndHandle(configuration: GradientHandleConfiguration) -> some View {
        Capsule()
            .foregroundColor(Color.white)
            .frame(width: 25, height: 75)
            .rotationEffect(configuration.angle + Angle(degrees: 90))
            .animation(.none)
            .shadow(radius: 3)
            .opacity(configuration.isHidden ? 0 : 1)
    }
    public func makeStop(configuration: GradientStopConfiguration) -> some View {
        Capsule()
            .foregroundColor(configuration.color)
            .frame(width: 20, height: 55)
            .overlay(Capsule().stroke( configuration.isSelected ? Color.yellow : Color.white ))
            .rotationEffect(configuration.angle + Angle(degrees: 90))
            .animation(.none)
            .shadow(color: configuration.isSelected ? Color.white : Color.black, radius: 3)
            .opacity(configuration.isHidden ? 0 : 1)
        
    }
}
@available(iOS 13.0, macOS 10.15, watchOS 6.0 , *)
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
            .animation(.easeIn)
    }
    public func makeStartHandle(configuration: GradientHandleConfiguration) -> some View {
        Circle()
            .stroke(Color.white.opacity(0.001), style: StrokeStyle(lineWidth: 10))
            .overlay(Circle().stroke(Color.black, style: StrokeStyle(lineWidth: 1, dash: [10, 5])))
            .opacity(configuration.isHidden ? 0 : 1)
            .animation(.easeIn)
    }
    public func makeEndHandle(configuration: GradientHandleConfiguration) -> some View {
        Circle()
            .stroke(Color.white.opacity(0.001), style: StrokeStyle(lineWidth: 10))
            .overlay(Circle().stroke(Color.white, style: StrokeStyle(lineWidth: 1, dash: [10, 5])))
            .opacity(configuration.isHidden ? 0 : 1)
            .animation(.easeIn)
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
                    .animation(Animation.easeOut)
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
                    .animation(Animation.easeOut)
            }
        }
    }
}
@available(iOS 13.0, macOS 10.15, watchOS 6.0 , *)
public struct DefaultAngularGradientPickerStyle: AngularGradientPickerStyle {
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
            .animation(.none)
            .shadow(radius: 3)
            .opacity(configuration.isHidden ? 0 : 1)
    }
    public func makeEndHandle(configuration: GradientHandleConfiguration) -> some View {
        Capsule()
            .foregroundColor(Color.white)
            .frame(width: 30, height: 75)
            .rotationEffect(configuration.angle)
            .animation(.none)
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
                    .animation(Animation.easeOut)
            }
        }
    }
}

// MARK: - Style Setup

// MARK: Linear
@available(iOS 13.0, macOS 10.15, watchOS 6.0 , *)
public protocol LinearGradientPickerStyle {
    associatedtype GradientView: View
    associatedtype StartHandle: View
    associatedtype EndHandle: View
    associatedtype Stop: View
    
    func makeGradient(gradient: LinearGradient) -> Self.GradientView
    func makeStartHandle(configuration: GradientHandleConfiguration) -> Self.StartHandle
    func makeEndHandle(configuration: GradientHandleConfiguration) -> Self.EndHandle
    func makeStop(configuration: GradientStopConfiguration) -> Self.Stop
}
@available(iOS 13.0, macOS 10.15, watchOS 6.0 , *)
public extension LinearGradientPickerStyle {
    func makeGradientTypeErased(gradient: LinearGradient) -> AnyView {
        AnyView(self.makeGradient(gradient: gradient))
    }
    func makeStartHandleTypeErased(configuration: GradientHandleConfiguration) -> AnyView {
        AnyView(self.makeStartHandle(configuration: configuration))
    }
    func makeEndHandleTypeErased(configuration: GradientHandleConfiguration) -> AnyView {
        AnyView(self.makeEndHandle(configuration: configuration))
    }
    func makeStopTypeErased(configuration: GradientStopConfiguration) -> AnyView {
        AnyView(self.makeStop(configuration: configuration))
    }
}
@available(iOS 13.0, macOS 10.15, watchOS 6.0 , *)
public struct AnyLinearGradientPickerStyle: LinearGradientPickerStyle {
    private let _makeGradient: (LinearGradient) -> AnyView
    public func makeGradient(gradient: LinearGradient) -> some View {
        return self._makeGradient(gradient)
    }
    private let _makeStartHandle: (GradientHandleConfiguration) -> AnyView
    public func makeStartHandle(configuration: GradientHandleConfiguration) -> some View {
        return self._makeStartHandle(configuration)
    }
    
    private let _makeEndHandle: (GradientHandleConfiguration) -> AnyView
    public func makeEndHandle(configuration: GradientHandleConfiguration) -> some View {
        return self._makeEndHandle(configuration)
    }
    
    private let _makeStop: (GradientStopConfiguration) -> AnyView
    public func makeStop(configuration: GradientStopConfiguration) -> some View {
        return self._makeStop(configuration)
    }
    
    public init<ST: LinearGradientPickerStyle>(_ style: ST) {
        self._makeGradient = style.makeGradientTypeErased
        self._makeStartHandle = style.makeStartHandleTypeErased
        self._makeEndHandle = style.makeEndHandleTypeErased
        self._makeStop = style.makeStopTypeErased
    }
}
@available(iOS 13.0, macOS 10.15, watchOS 6.0 , *)
public struct LinearGradientPickerStyleKey: EnvironmentKey {
    public static let defaultValue: AnyLinearGradientPickerStyle  = AnyLinearGradientPickerStyle(DefaultLinearGradientPickerStyle())
}
@available(iOS 13.0, macOS 10.15, watchOS 6.0 , *)
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
@available(iOS 13.0, macOS 10.15, watchOS 6.0 , *)
extension View {
    public func linearGradientPickerStyle<S>(_ style: S) -> some View where S: LinearGradientPickerStyle {
        self.environment(\.linearGradientPickerStyle, AnyLinearGradientPickerStyle(style))
    }
}

// MARK:  Radial
@available(iOS 13.0, macOS 10.15, watchOS 6.0 , *)
public protocol RadialGradientPickerStyle {
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
@available(iOS 13.0, macOS 10.15, watchOS 6.0 , *)
public extension RadialGradientPickerStyle {
    func makeGradientTypeErased(gradient: RadialGradient) -> AnyView {
        AnyView(self.makeGradient(gradient: gradient))
    }
    func makeCenterTypeErased(configuration: GradientCenterConfiguration) -> AnyView {
        AnyView(self.makeCenter(configuration: configuration))
    }
    func makeStartHandleTypeErased(configuration: GradientHandleConfiguration) -> AnyView {
        AnyView(self.makeStartHandle(configuration: configuration))
    }
    func makeEndHandleTypeErased(configuration: GradientHandleConfiguration) -> AnyView {
        AnyView(self.makeEndHandle(configuration: configuration))
    }
    func makeStopTypeErased(configuration: GradientStopConfiguration) -> AnyView {
        AnyView(self.makeStop(configuration: configuration))
    }
    
    func makeBarTypeErased(configuration: RadialGradientBarConfiguration) -> AnyView {
        AnyView(self.makeBar(configuration: configuration))
    }
}
@available(iOS 13.0, macOS 10.15, watchOS 6.0 , *)
public struct AnyRadialGradientPickerStyle: RadialGradientPickerStyle {
    private let _makeGradient: (RadialGradient) -> AnyView
    public func makeGradient(gradient: RadialGradient) -> some View {
        return self._makeGradient(gradient)
    }
    private let _makeCenter: (GradientCenterConfiguration) -> AnyView
    public func makeCenter(configuration: GradientCenterConfiguration) -> some View {
        return self._makeCenter(configuration)
    }
    
    private let _makeStartHandle: (GradientHandleConfiguration) -> AnyView
    public func makeStartHandle(configuration: GradientHandleConfiguration) -> some View {
        return self._makeStartHandle(configuration)
    }
    
    private let _makeEndHandle: (GradientHandleConfiguration) -> AnyView
    public func makeEndHandle(configuration: GradientHandleConfiguration) -> some View {
        return self._makeEndHandle(configuration)
    }
    
    private let _makeStop: (GradientStopConfiguration) -> AnyView
    public func makeStop(configuration: GradientStopConfiguration) -> some View {
        return self._makeStop(configuration)
    }
    private let _makeBar: (RadialGradientBarConfiguration) -> AnyView
    public func makeBar(configuration: RadialGradientBarConfiguration) -> some View {
        return self._makeBar(configuration)
    }
    
    
    
    public init<ST: RadialGradientPickerStyle>(_ style: ST) {
        self._makeGradient = style.makeGradientTypeErased
        self._makeCenter = style.makeCenterTypeErased
        self._makeStartHandle = style.makeStartHandleTypeErased
        self._makeEndHandle = style.makeEndHandleTypeErased
        self._makeStop = style.makeStopTypeErased
        self._makeBar = style.makeBarTypeErased
    }
}
@available(iOS 13.0, macOS 10.15, watchOS 6.0 , *)
public struct RadialGradientPickerStyleKey: EnvironmentKey {
    public static let defaultValue: AnyRadialGradientPickerStyle  = AnyRadialGradientPickerStyle(DefaultRadialGradientPickerStyle())
}
@available(iOS 13.0, macOS 10.15, watchOS 6.0 , *)
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
@available(iOS 13.0, macOS 10.15, watchOS 6.0 , *)
extension View {
    public func radialGradientPickerStyle<S>(_ style: S) -> some View where S: RadialGradientPickerStyle {
        self.environment(\.radialGradientPickerStyle, AnyRadialGradientPickerStyle(style))
    }
}

// MARK:  Angular
@available(iOS 13.0, macOS 10.15, watchOS 6.0 , *)
public protocol AngularGradientPickerStyle {
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
@available(iOS 13.0, macOS 10.15, watchOS 6.0 , *)
public extension AngularGradientPickerStyle {
    func makeGradientTypeErased(gradient: AngularGradient) -> AnyView {
        AnyView(self.makeGradient(gradient: gradient))
    }
    func makeCenterTypeErased(configuration: GradientCenterConfiguration) -> AnyView {
        AnyView(self.makeCenter(configuration: configuration))
    }
    func makeStartHandleTypeErased(configuration: GradientHandleConfiguration) -> AnyView {
        AnyView(self.makeStartHandle(configuration: configuration))
    }
    func makeEndHandleTypeErased(configuration: GradientHandleConfiguration) -> AnyView {
        AnyView(self.makeEndHandle(configuration: configuration))
    }
    func makeStopTypeErased(configuration: GradientStopConfiguration) -> AnyView {
        AnyView(self.makeStop(configuration: configuration))
    }
}
@available(iOS 13.0, macOS 10.15, watchOS 6.0 , *)
public struct AnyAngularGradientPickerStyle: AngularGradientPickerStyle {
    private let _makeGradient: (AngularGradient) -> AnyView
    public func makeGradient(gradient: AngularGradient) -> some View {
        return self._makeGradient(gradient)
    }
    private let _makeCenter: (GradientCenterConfiguration) -> AnyView
    public func makeCenter(configuration: GradientCenterConfiguration) -> some View {
        return self._makeCenter(configuration)
    }
    
    private let _makeStartHandle: (GradientHandleConfiguration) -> AnyView
    public func makeStartHandle(configuration: GradientHandleConfiguration) -> some View {
        return self._makeStartHandle(configuration)
    }
    
    private let _makeEndHandle: (GradientHandleConfiguration) -> AnyView
    public func makeEndHandle(configuration: GradientHandleConfiguration) -> some View {
        return self._makeEndHandle(configuration)
    }
    
    private let _makeStop: (GradientStopConfiguration) -> AnyView
    public func makeStop(configuration: GradientStopConfiguration) -> some View {
        return self._makeStop(configuration)
    }
    
    
    public init<ST: AngularGradientPickerStyle>(_ style: ST) {
        self._makeGradient = style.makeGradientTypeErased
        self._makeCenter = style.makeCenterTypeErased
        self._makeStartHandle = style.makeStartHandleTypeErased
        self._makeEndHandle = style.makeEndHandleTypeErased
        self._makeStop = style.makeStopTypeErased
        
    }
}
@available(iOS 13.0, macOS 10.15, watchOS 6.0 , *)
public struct AngularGradientPickerStyleKey: EnvironmentKey {
    public static let defaultValue: AnyAngularGradientPickerStyle  = AnyAngularGradientPickerStyle(DefaultAngularGradientPickerStyle())
}
@available(iOS 13.0, macOS 10.15, watchOS 6.0 , *)
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
@available(iOS 13.0, macOS 10.15, watchOS 6.0 , *)
extension View {
    public func angularGradientPickerStyle<S>(_ style: S) -> some View where S: AngularGradientPickerStyle {
        self.environment(\.angularGradientPickerStyle, AnyAngularGradientPickerStyle(style))
    }
}
