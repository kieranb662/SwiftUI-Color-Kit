//
//  LinearGradientPicker.swift
//  MyExamples
//
//  Created by Kieran Brown on 4/3/20.
//  Copyright © 2020 BrownandSons. All rights reserved.
//

import SwiftUI
import CGExtender



// MARK: Stop

/// # Linear Gradient Stop
///
/// Draggable view used to represent a gradient stop along a `LinearGradient`
///
/// ## How It Works
/// By calculating the projection of the drag gestures location onto the line segment defined between the start and end values
/// The projected point which lies on the infinited line defined by the angle between the start and end values is then constrained to the line segment using
/// the parametric form of the line.
@available(iOS 13.0, macOS 10.15, watchOS 6.0 , *)
public struct LinearStop: View {
    @Environment(\.linearGradientPickerStyle) private var style: AnyLinearGradientPickerStyle
    @Binding var stop: GradientData.Stop
    @Binding var selected: UUID?
    var isHidden: Bool
    @State private var isActive: Bool = false // Used to keep track of the Stops drag state
    private let space: String = "Linear Gradient" // Linear Gradients coordinate space identifier
    public let id: UUID // Used to identify the stop
    public let start: CGPoint // Current location of the start handle
    public let end: CGPoint // Current location of the end handle
    // calculates the angle of the line segment defined by the start and end locations and the adds 90 degrees
    // so the the handles and stops are parrallel with the gradient
    private var angle: Angle {
        let diff = end - start
        return Angle(radians: diff.x == 0 ? Double.pi/2 : atan(Double(diff.y/diff.x)) +  .pi/2)
    }
    // Uses the parametric form of the line defined between the start and end handles to calculate the location of the stop
    private var lerp: CGPoint {
        
        let x = (1-stop.location)*start.x + stop.location*end.x
        let y = (1-stop.location)*start.y + stop.location*end.y
        return CGPoint(x: x, y: y)
    }
    private var configuration: GradientStopConfiguration {
        return .init(isActive,
                     selected == id,
                     isHidden,
                     stop.color.color,
                     angle)
    }
    func select() {
        if selected == id {
            self.selected = nil
        } else {
            self.selected = id
        }
    }
    
    public var body: some View {
        GeometryReader { proxy in
            ZStack {
                self.style.makeStop(configuration: self.configuration)
                    .offset(x: self.lerp.x - proxy.size.width/2, y: self.lerp.y - proxy.size.height/2)
                    .onTapGesture { self.select() }
                    .simultaneousGesture(DragGesture(minimumDistance: 10, coordinateSpace: .named(self.space))
                        .onChanged({
                            self.stop.location = calculateParameter(self.start, self.end, $0.location)
                            self.isActive = true
                        })
                        .onEnded({
                            self.stop.location = calculateParameter(self.start, self.end, $0.location)
                            self.isActive = false
                        }))
            }
            
        }
    }
}


// MARK: Picker
/// # Linear Gradient Picker
///
/// A Component view used to create and style a `Linear Gradient` to the users liking
///  The sub components that make up the gradient picker are
///  1. Gradient: The Linear gradient containing view
///  2 Start Handle: A draggable view representing the start location of the gradient
///  3. End Handle: A draggable view representing the end location of the gradient
///  4. LinearStop: A draggable view  representing a gradient stop that is constrained to be located within the start and and handles locations
///
/// - important: You must create a `GradientManager` `ObservedObject` and then apply it to the `LinearGradientPicker`
///   or the view containing it using the `environmentObject` method
///
///  ## Styling The Picker
/// In order to style the picker you must create a struct that conforms to the `LinearGradientPickerStyle` protocol. Conformance requires the implementation of
///  3 separate methods. To make this easier just copy and paste the following style based on the `DefaultLinearGradientPickerStyle`. After creating your custom style
///  apply it by calling the `linearGradientPickerStyle` method on the `LinearGradientPicker` or a view containing it.
///
/// ```
///      struct <#My Picker Style#>: LinearGradientPickerStyle {
///
///         func makeGradient(gradient: LinearGradient) -> some View {
///                RoundedRectangle(cornerRadius: 5)
///                    .fill(gradient)
///                    .overlay(RoundedRectangle(cornerRadius: 5).stroke(Color.white))
///            }
///          func makeStartHandle(configuration: GradientHandleConfiguration) -> some View {
///              Capsule()
///                  .foregroundColor(Color.white)
///                  .frame(width: 25, height: 75)
///                  .rotationEffect(configuration.angle + Angle(degrees: 90))
///                  .animation(.none)
///                  .shadow(radius: 3)
///                  .opacity(configuration.isHidden ? 0 : 1)
///          }
///          func makeEndHandle(configuration: GradientHandleConfiguration) -> some View {
///              Capsule()
///                  .foregroundColor(Color.white)
///                  .frame(width: 25, height: 75)
///                  .rotationEffect(configuration.angle + Angle(degrees: 90))
///                  .animation(.none)
///                  .shadow(radius: 3)
///                  .opacity(configuration.isHidden ? 0 : 1)
///          }
///          func makeStop(configuration: GradientStopConfiguration) -> some View {
///              Capsule()
///                  .foregroundColor(configuration.color)
///                  .frame(width: 20, height: 55)
///                  .overlay(Capsule().stroke( configuration.isSelected ? Color.yellow : Color.white ))
///                  .rotationEffect(configuration.angle + Angle(degrees: 90))
///                  .animation(.none)
///                  .shadow(color: configuration.isSelected ? Color.white : Color.black, radius: 3)
///                  .opacity(configuration.isHidden ? 0 : 1)
///
///          }
///      }
///
///  ```
@available(iOS 13.0, macOS 10.15, watchOS 6.0 , *)
public struct LinearGradientPicker: View {
    @Environment(\.linearGradientPickerStyle) private var style: AnyLinearGradientPickerStyle
    @EnvironmentObject private var manager: GradientManager
    private let space: String = "Linear Gradient"
    @GestureState private var startState: DragState = .inactive // Gesture state for the start point thumb
    @GestureState private var endState: DragState = .inactive // Gesture state for the end point thumb
    public init() {}
    enum DragState {
        case inactive
        case pressing
        case dragging(translation: CGSize)
        
        var translation: CGSize {
            switch self {
            case .inactive, .pressing:
                return .zero
            case .dragging(let translation):
                return translation
            }
        }
        
        var isActive: Bool {
            switch self {
            case .inactive:
                return false
            case .pressing, .dragging:
                return true
            }
        }
        
        var isDragging: Bool {
            switch self {
            case .inactive, .pressing:
                return false
            case .dragging:
                return true
            }
        }
    }
    
    // MARK: Convenience Values
    
    /// The starts current location in unit point form
    private func currentUnitStart(_ proxy: GeometryProxy) -> UnitPoint {
        if proxy.size.width == 0 || proxy.size.height == 0 { return UnitPoint.zero }
        return UnitPoint(x: self.manager.gradient.start.x + self.startState.translation.width/proxy.size.width,
                         y: self.manager.gradient.start.y + self.startState.translation.height/proxy.size.height)
    }
    /// The ends current location in unit point form
    private func currentUnitEnd(_ proxy: GeometryProxy) -> UnitPoint {
        if proxy.size.width == 0 || proxy.size.height == 0 { return UnitPoint.zero}
        return UnitPoint(x: self.manager.gradient.end.x + self.endState.translation.width/proxy.size.width,
                         y: self.manager.gradient.end.y + self.endState.translation.height/proxy.size.height)
    }
    /// The starts current location
    private func currentStartPoint(_ proxy: GeometryProxy) -> CGPoint {
        if proxy.size.width == 0 || proxy.size.height == 0 { return .zero }
        return CGPoint(x: self.manager.gradient.start.x*proxy.size.width + self.startState.translation.width,
                       y: self.manager.gradient.start.y*proxy.size.height + self.startState.translation.height)
    }
    /// The ends current location
    private func currentEndPoint(_ proxy: GeometryProxy) -> CGPoint {
        if proxy.size.width == 0 || proxy.size.height == 0 { return .zero }
        return CGPoint(x: self.manager.gradient.end.x*proxy.size.width + self.endState.translation.width,
                       y: self.manager.gradient.end.y*proxy.size.height + self.endState.translation.height)
    }
    /// Here the angle is calculated using the actual sizes of the Rectangle rather than the UnitPoint values
    /// This is because UnitPoints represent perfect squares with a side length of 1, therefore any angle calculated
    /// would be for a square region rather than a rectangular
    private func angle(_ proxy: GeometryProxy) -> Angle {
        let diff = currentEndPoint(proxy)-currentStartPoint(proxy)
        return Angle(radians: diff.x == 0 ? Double.pi/2 : atan(Double(diff.y/diff.x)) +  .pi/2)
    }
    
    // MARK: Views
    /// Makes The Linear Gradient
    private func makeGradient(_ proxy: GeometryProxy) -> some View {
        style.makeGradient(gradient: LinearGradient(gradient: self.manager.gradient.gradient,
                                                    startPoint: self.currentUnitStart(proxy),
                                                    endPoint: self.currentUnitEnd(proxy)))
            
            .drawingGroup(opaque: false, colorMode: self.manager.gradient.renderMode.renderingMode)
            .animation(.interactiveSpring())
    }
    /// Creates a the views to be used as either the startHandle or endHandle
    private func makeHandle(_ proxy: GeometryProxy, _ point: Binding<UnitPoint>, _ state: GestureState<DragState>) -> some View {
        let offsetX = point.x.wrappedValue*proxy.size.width + state.wrappedValue.translation.width - proxy.size.width/2
        let offsetY = point.y.wrappedValue*proxy.size.height + state.wrappedValue.translation.height - proxy.size.height/2
        
        let longPressDrag = LongPressGesture(minimumDuration: 0.05)
            .sequenced(before: DragGesture())
            .updating(state) { value, state, transaction in
                switch value {
                case .first(true):            // Long press begins.
                    state = .pressing
                case .second(true, let drag): // Long press confirmed, dragging may begin.
                    state = .dragging(translation: drag?.translation ?? .zero)
                default:                      // Dragging ended or the long press cancelled.
                    state = .inactive
                }
        }
        .onEnded { value in
            guard case .second(true, let drag?) = value else { return }
            point.wrappedValue = UnitPoint(x: drag.translation.width/proxy.size.width + point.wrappedValue.x,
                                           y: drag.translation.height/proxy.size.height + point.wrappedValue.y)
        }
        let configuration: GradientHandleConfiguration = .init(state.wrappedValue.isActive,
                                                               state.wrappedValue.isDragging,
                                                               manager.hideTools,
                                                               angle(proxy))
        
        return style.makeStartHandle(configuration: configuration)
            .offset(x: offsetX, y: offsetY)
            .gesture(longPressDrag)
        
    }
    private func makeStops(_ proxy: GeometryProxy) -> some View {
        ForEach(self.manager.gradient.stops.indices, id: \.self) { (i) in
            LinearStop(stop: self.$manager.gradient.stops[i],
                       selected: self.$manager.selected,
                       isHidden: self.manager.hideTools,
                       id: self.manager.gradient.stops[i].id,
                       start: self.currentStartPoint(proxy),
                       end: self.currentEndPoint(proxy))
        }
    }
    
    public var body: some View {
        GeometryReader { proxy in
            ZStack {
                self.makeGradient(proxy)
                self.makeHandle(proxy, self.$manager.gradient.start, self.$startState) // Start Handle
                self.makeHandle(proxy, self.$manager.gradient.end, self.$endState) // End Handle
                self.makeStops(proxy)
                
            }.coordinateSpace(name: self.space)
        }
    }
}

