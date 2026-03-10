// Swift toolchain version 6.0
// Running macOS version 26.3
// Created on 4/5/20.
//
// Author: Kieran Brown
//

import SwiftUI

// MARK:  Stop

/// # Radial Gradient Stop
///
/// Draggable view used to represent a gradient stop within a radial gradient.
///
/// ## How it works
/// In the body of the view I created an exact copy of the stop but with an opacity of 0 making it invisible.
/// Then I used the `RadialKey` with the `anchorPreference` method to capture the bounds of the stop
/// Finally I used `overlayPreferenceValue` to overlay a visible copy of the stop which used the invisible copie's bounds
/// to restrict the translation of the view from being partaill dragged over either edge of the `RadialGradientPicker`'s gradient bar.
public struct RadialStop: View {
    // Preference key used to grab the size of the stop and then adjust the maximum translation
    // so that the stop doesnts get partially dragged over the ends of the gradient bar
    private struct RadialKey: PreferenceKey {
        static var defaultValue: CGRect {  .zero }
        static func reduce(value: inout CGRect, nextValue: () -> CGRect) {
            value = nextValue()
        }
    }
    @Environment(\.radialGradientPickerStyle) private var style: AnyRadialGradientPickerStyle
    @Binding var stop: GradientData.Stop
    @Binding var selected: UUID?
    var isHidden: Bool
    public let id: UUID // Used to identify the stop
    
    @State private var isActive: Bool = false // Used to keep track of the Stops drag state
    private let space: String = "Radial Gradient" // Radial Gradients coordinate space identifier
    
    private var configuration: GradientStopConfiguration {
        return .init(isActive, selected == id, isHidden, stop.color.color, .zero)
    }
    
    func select() {
        if selected == id {
            selected = nil
        } else {
            selected = id
        }
    }
    
    public var body: some View {
        GeometryReader { proxy in
            ZStack {
                style
                    .makeStop(configuration: configuration).opacity(0)
                    .anchorPreference(key: RadialKey.self, value: .bounds, transform: { proxy[$0] })
                    .overlayPreferenceValue(RadialKey.self, { (rect)  in
                        style.makeStop(configuration: configuration)
                            .offset(x: (stop.location - 0.5)*(proxy.size.width-rect.width-4), y: 0)
                            .onTapGesture { select() }
                            .simultaneousGesture(
                                DragGesture(minimumDistance: 10, coordinateSpace: .named(space))
                                    .onChanged {
                                        stop.location = max(min($0.location.x/proxy.size.width, 1),0)
                                        isActive = true
                                    }
                                    .onEnded {
                                        stop.location = max(min($0.location.x/proxy.size.width, 1),0)
                                        isActive = false
                                    }
                            )
                    })
            }
        }
    }
}

// MARK:  Picker

/// # Radial Gradient Picker
///
///
/// A Component view used to create and style a `RadialGradient` to the users liking
/// The sub components that make up the gradient picker are
/// 1. **Gradient**: The Radial Gradient containing view
/// 2. **Center Thumb**: A draggable view representing the center of the gradient
/// 3. **StartHandle**: A draggable circle representing the start radius  that grows larger/small as you drag away/closer from the center thumb
/// 4. **EndHandle**: A draggable circle representing the end radius  that grows larger/small as you drag away/closer from the center thumb
/// 5. **RadialStop**: A draggable view contained to the gradient bar, represents the unit location of the stop
/// 6. **Gradient Bar**: A slider like container filled with a linear gradient created with the gradient stops.
///
/// - important: You must create a `GradientManager` `ObservedObject` and then apply it to the `RadialGradientPicker`
///   or the view containing it using the `environmentObject` method
///
///
///  ## Styling The Picker
/// In order to style the picker you must create a struct that conforms to the `RadialGradientPickerStyle` protocol. Conformance requires the implementation of
///  5 separate methods. To make this easier just copy and paste the following style based on the `DefaultRadialGradientPickerStyle`. After creating your custom style
///  apply it by calling the `radialGradientPickerStyle` method on the `RadialGradientPicker` or a view containing it.
///
///  ```
///        struct <#My Picker Style#>: RadialGradientPickerStyle {
///
///             func makeGradient(gradient: RadialGradient) -> some View {
///                 RoundedRectangle(cornerRadius: 5)
///                     .fill(gradient)
///                     .overlay(RoundedRectangle(cornerRadius: 5).stroke(Color.white))
///             }
///            func makeCenter(configuration: GradientCenterConfiguration) -> some View {
///                Circle().fill(configuration.isActive ? Color.yellow : Color.white)
///                    .frame(width: 35, height: 35)
///                    .opacity(configuration.isHidden ? 0 : 1)
///                    .animation(.easeIn)
///            }
///            func makeStartHandle(configuration: GradientHandleConfiguration) -> some View {
///                Circle()
///                    .stroke(Color.white.opacity(0.001), style: StrokeStyle(lineWidth: 10))
///                    .overlay(Circle().stroke(Color.black, style: StrokeStyle(lineWidth: 1, dash: [10, 5])))
///                    .opacity(configuration.isHidden ? 0 : 1)
///                    .animation(.easeIn)
///            }
///            func makeEndHandle(configuration: GradientHandleConfiguration) -> some View {
///                Circle()
///                    .stroke(Color.white.opacity(0.001), style: StrokeStyle(lineWidth: 10))
///                    .overlay(Circle().stroke(Color.white, style: StrokeStyle(lineWidth: 1, dash: [10, 5])))
///                    .opacity(configuration.isHidden ? 0 : 1)
///                    .animation(.easeIn)
///            }
///            func makeStop(configuration: GradientStopConfiguration) -> some View {
///                Group {
///                    if !configuration.isHidden {
///                        RoundedRectangle(cornerRadius: 5)
///                            .foregroundColor(configuration.color)
///                            .frame(width: 25, height: 45)
///                            .overlay(RoundedRectangle(cornerRadius: 5).stroke( configuration.isSelected ? Color.yellow : Color.white ))
///                            .shadow(color: configuration.isSelected ? Color.white : Color.black, radius: 3)
///                            .transition(AnyTransition.opacity)
///                            .animation(Animation.easeOut)
///                    }
///                }
///            }
///            func makeBar(configuration: RadialGradientBarConfiguration) -> some View {
///                Group {
///                    if !configuration.isHidden {
///                        RoundedRectangle(cornerRadius: 5)
///                            .fill(LinearGradient(gradient: configuration.gradient, startPoint: .leading, endPoint: .trailing))
///                            .overlay(RoundedRectangle(cornerRadius: 5).stroke(Color.white))
///                            .transition(AnyTransition.move(edge: .leading))
///                            .animation(Animation.easeOut)
///                    }
///                }
///            }
///        }
/// ```
public struct RadialGradientPicker: View {
    // MARK: State and Utilities
    @Environment(\.radialGradientPickerStyle) private var style: AnyRadialGradientPickerStyle
    @EnvironmentObject private var manager: GradientManager
    @State private var centerState: CGSize = .zero // Value representing the actual drag transaltion of the center thumb
    @State private var startState: Double = 0 // Value on [0,1] representing the current dragging of the start handle
    @State private var endState: Double = 0 // Value on [0,1] representing the current dragging of the end handle
    private let space: String = "Radial Gradient"  // Indentifier used to denote the pickers coordinate space
    
    public init() {}
    
    // The current Unit location of the center thumb
    private func currentCenter(_ proxy: GeometryProxy) -> UnitPoint {
        let x = manager.gradient.center.x + centerState.width/proxy.size.width
        let y = manager.gradient.center.y + centerState.height/proxy.size.height
        return UnitPoint(x: x, y: y)
    }
    
    // the current position of the center thumv
    private func currentCenter(_ proxy: GeometryProxy) -> CGPoint {
        let x = manager.gradient.center.x*proxy.size.width
        let y = manager.gradient.center.y*proxy.size.height
        return CGPoint(x: x+centerState.width, y: y+centerState.height)
    }
    
    // MARK: Views
    // Creates the radial gradient
    private func makeGradient(_ proxy: GeometryProxy) ->  some View {
        style.makeGradient(
            gradient: RadialGradient(gradient: manager.gradient.gradient,
                                     center: currentCenter(proxy),
                                     startRadius: manager.gradient.startRadius + CGFloat(startState),
                                     endRadius: manager.gradient.endRadius + CGFloat(endState))
        )
        .drawingGroup(opaque: false, colorMode: manager.gradient.renderMode.renderingMode)
    }
    
    // Creates the center thumb representing the center of the gradient
    private func makeCenter(_ proxy: GeometryProxy) -> some View {
        style.makeCenter(
            configuration: .init(isActive: centerState != .zero, isHidden: manager.hideTools)
        )
        .position(currentCenter(proxy))
        .gesture(
            DragGesture(minimumDistance: 0, coordinateSpace: .named(space))
                .onChanged({centerState = $0.translation})
                .onEnded({
                    let x = $0.location.x/proxy.size.width
                    let y = $0.location.y/proxy.size.height
                    manager.gradient.center = UnitPoint(x: x, y: y)
                    centerState = .zero
                })
        )
    }
    
    // Creates the draggable Circle representing the endRadius of the gradient
    private func makeEndHandle(_ proxy: GeometryProxy) -> some View {
        style.makeEndHandle(
            configuration: .init(endState != 0, endState != 0, manager.hideTools, .zero)
        )
        .frame(width: 2*(manager.gradient.endRadius + CGFloat(endState)))
        .gesture(
            DragGesture(minimumDistance: 0, coordinateSpace: .named(space))
                .onChanged({
                    endState = sqrt(($0.location - currentCenter(proxy)).magnitudeSquared) - Double(manager.gradient.endRadius)
                }).onEnded({
                    manager.gradient.endRadius = CGFloat(sqrt(($0.location - currentCenter(proxy)).magnitudeSquared))
                    endState = 0
                })
        )
        .position(currentCenter(proxy))
    }
    
    // The Gradient filled bar that acts as a slider for the gradient stops
    private var gradientBar: some View {
        ZStack {
            style.makeBar(
                configuration: .init(gradient: manager.gradient.gradient, isHidden: manager.hideTools)
            )
            
            ForEach(manager.gradient.stops.indices, id: \.self) { (i) in
                RadialStop(stop: $manager.gradient.stops[i],
                           selected: $manager.selected,
                           isHidden: manager.hideTools,
                           id: manager.gradient.stops[i].id)
            }
        }
        .frame(height: 50)
        .coordinateSpace(name: space)
    }
    
    public var body: some View {
        VStack(spacing: 0) {
            ZStack {
                GeometryReader { proxy in
                    ZStack {
                        makeGradient(proxy)
                        makeCenter(proxy)
                        makeEndHandle(proxy)
                    }
                }
            }
            .aspectRatio(1, contentMode: .fit)
            .coordinateSpace(name: space)
            
            gradientBar
        }
    }
}

