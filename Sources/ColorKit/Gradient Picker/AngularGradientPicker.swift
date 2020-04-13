//
//  AngularGradientPicker.swift
//  MyExamples
//
//  Created by Kieran Brown on 4/5/20.
//  Copyright © 2020 BrownandSons. All rights reserved.
//

import SwiftUI
import CGExtender


// MARK: Stop
/// # Angular Gradient Stop
///
/// Draggable view used to represent a gradient stop along a `AngularGradient`
///
/// ## How It Works
/// By calculating the direction between the stops drag location and the centers thumb location. The angle is then converted to  value between [0,1]
/// Then the angle is constrained to between the start and end handles current angles.
@available(iOS 13.0, macOS 10.15, watchOS 6.0 , *)
public struct AngularStop: View {
    @Environment(\.angularGradientPickerStyle) private var style: AnyAngularGradientPickerStyle
    // MARK: Input Values
    @Binding var stop: GradientData.Stop
    @Binding var selected: UUID?
    var isHidden: Bool
    public let id: UUID
    public let start: Double
    public let end: Double
    public let center: CGPoint
    
    @State private var isActive: Bool = false
    private let space: String = "Angular Gradient"
    
    private var configuration: GradientStopConfiguration {
        let angle = Double(stop.location)*(start > end ? end+1-start: end-start) + start
        return .init(isActive, selected == id, isHidden, stop.color.color, Angle(degrees: angle*360))
    }
    
    // MARK:  Stop Utilities
    
    // The curent offset of the gradient stop from the center thumb
    private func offset(_ proxy: GeometryProxy) -> CGSize {
        let angle = Double(stop.location)*(start > end ? end+1-start: end-start) + start
        let r = Double(proxy.size.width > proxy.size.height ? proxy.size.height/2 : proxy.size.width/2) - 20
        let x = r*cos((angle) * 2 * .pi)
        let y = r*sin((angle) * 2 * .pi)
        
        return CGSize(width: x, height: y)
    }
    // All I have to say about this abomination is that "If it fits it ships"
    // The main issue is that my reference angle does not behave the same as the
    // angular gradients does, so in order to have expected behavior, this is how it is done
    private func calculateStopLocation(_ location: CGPoint) {
        var direction = calculateDirection(self.center, location)
        if self.start > self.end {
            if direction > self.start && direction < 1 {
                direction = (direction - self.start)/(self.end+1 - self.start)
                self.stop.location = CGFloat(direction)
            } else {
                direction = max(min(direction + 1 , self.end + 1), self.start)
                self.stop.location = abs(CGFloat((direction-self.start)/((self.end+1)-self.start) ))
            }
        } else {
            direction = max(min(direction, self.end), self.start)
            self.stop.location = CGFloat((direction-self.start)/(self.end-self.start) )
        }
    }
    func select() {
        if selected == id {
            self.selected = nil
        } else {
            self.selected = id
        }
    }
    // MARK: Stop Body
    public var body: some View {
        GeometryReader { proxy in
            ZStack {
                self.style.makeStop(configuration: self.configuration)
                    .offset(self.offset(proxy))
                    .onTapGesture { self.select()}
                    .simultaneousGesture(DragGesture(minimumDistance: 5, coordinateSpace: .named(self.space))
                        .onChanged({
                            self.calculateStopLocation($0.location)
                            self.isActive = true
                        }).onEnded({
                            self.calculateStopLocation($0.location)
                            self.isActive = false
                        }))
            }
        }
    }
}


// MARK:  Picker

/// # Angular Gradient Picker
///
/// A Component view used to create and style an `AngularGradient` to the users liking
///  The sub components that make up the gradient picker are
///  1. **Gradient**: The Angular Gradient containing view 
///  2. **Center Thumb**: A draggable view representing the location of the gradients center
///  3. **Start Handle**: A draggable view representing the start location of the gradient
///  4. **End Handle**: A draggable view representing the end location of the gradient
///  5. **AngularStop**: A draggable view  representing a gradient stop that is constrained to be between the current stop and end angles locations
///
/// - important: You must create a `GradientManager` `ObservedObject` and then apply it to the `AngularGradientPicker`
///   or the view containing it using the `environmentObject` method
///
///  ## Styling The Picker
///
/// In order to style the picker you must create a struct that conforms to the `AngularGradientPickerStyle` protocol. Conformance requires the implementation of
/// 4 separate methods. To make this easier just copy and paste the following style based on the `DefaultAngularGradientPickerStyle`. After creating your custom style
/// apply it by calling the `angularGradientPickerStyle` method on the `AngularGradientPicker` or a view containing it.
///
/// ```
///      struct <#My Picker Style#>: AngularGradientPickerStyle {
///
///         func makeGradient(gradient: AngularGradient) -> some View {
///             RoundedRectangle(cornerRadius: 5)
///                 .fill(gradient)
///                 .overlay(RoundedRectangle(cornerRadius: 5).stroke(Color.white))
///         }
///          func makeCenter(configuration: GradientCenterConfiguration) -> some View {
///              Circle().fill(configuration.isActive ? Color.yellow : Color.white)
///                  .frame(width: 35, height: 35)
///                  .opacity(configuration.isHidden ? 0 : 1)
///          }
///          func makeStartHandle(configuration: GradientHandleConfiguration) -> some View {
///              Capsule()
///                  .foregroundColor(Color.white)
///                  .frame(width: 30, height: 75)
///                  .rotationEffect(configuration.angle)
///                  .animation(.none)
///                  .shadow(radius: 3)
///                  .opacity(configuration.isHidden ? 0 : 1)
///          }
///          func makeEndHandle(configuration: GradientHandleConfiguration) -> some View {
///              Capsule()
///                  .foregroundColor(Color.white)
///                  .frame(width: 30, height: 75)
///                  .rotationEffect(configuration.angle)
///                  .animation(.none)
///                  .shadow(radius: 3)
///                  .opacity(configuration.isHidden ? 0 : 1)
///          }
///          func makeStop(configuration: GradientStopConfiguration) -> some View {
///              Group {
///                  if !configuration.isHidden {
///                      Circle()
///                          .foregroundColor(configuration.color)
///                          .frame(width: 25, height: 45)
///                          .overlay(Circle().stroke( configuration.isSelected ? Color.yellow : Color.white ))
///                          .shadow(color: configuration.isSelected ? Color.white : Color.black, radius: 3)
///                          .transition(AnyTransition.opacity)
///                          .animation(Animation.easeOut)
///                  }
///              }
///          }
///      }
/// ```
@available(iOS 13.0, macOS 10.15, watchOS 6.0 , *)
public struct AngularGradientPicker: View {
    // MARK:  State and Support Values
    @Environment(\.angularGradientPickerStyle) private var style: AnyAngularGradientPickerStyle
    @EnvironmentObject private var manager: GradientManager
    private let space: String = "Angular Gradient" // Used to name the coordinate space of the picker
    @State private var centerState: CGSize = .zero // Value representing the actual drag transaltion of the center thumb
    @State private var startState: Double = 0 // Value on [0,1] representing the current dragging of the start handle
    @State private var endState: Double = 0 // Value on [0,1] representing the current dragging of the end handle
    public init() {}
    // Convience value that calculates and adjusts the current start and end states such that the end value is always greater than the start
    private var currentStates: (start: Double, end: Double) {
        let start = startState + self.manager.gradient.startAngle
        let end = endState + manager.gradient.endAngle
        if start > end {
            return (start , end + 1)
        } else {
            return (start, end)
        }
    }
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
    // The Start handles current offset from the center
    private func startOffset(_ proxy: GeometryProxy) -> CGSize {
        let angle = (manager.gradient.startAngle + startState)*2 * .pi
        let r = Double(proxy.size.width > proxy.size.height ? proxy.size.height/2 : proxy.size.width/2) - 20
        let x = r*cos(angle)
        let y = r*sin(angle)
        return CGSize(width: x, height: y)
    }
    // The end handles current offset from the center
    private func endOffset(_ proxy: GeometryProxy) -> CGSize {
        let angle = (manager.gradient.endAngle + endState)*2 * .pi
        let r = Double(proxy.size.width > proxy.size.height ? proxy.size.height/2 : proxy.size.width/2) - 20
        let x = r*cos(angle)
        let y = r*sin(angle)
        return CGSize(width: x, height: y)
    }
    
    // MARK:  Views
    // Creates the Angular Gradient
    private func gradient(_ proxy: GeometryProxy) -> some View {
        style.makeGradient(gradient: AngularGradient(gradient: self.manager.gradient.gradient,
                                                     center: self.currentCenter(proxy),
                                                     startAngle: Angle(radians: self.currentStates.start*2 * .pi),
                                                     endAngle: Angle(radians: self.currentStates.end*2 * .pi)))
            .drawingGroup(opaque: false, colorMode: self.manager.gradient.renderMode.renderingMode)
            .animation(.linear)
    }
    // Created the center thumb
    private func center(_ proxy: GeometryProxy) -> some View {
        self.style.makeCenter(configuration: .init(isActive: self.centerState != .zero, isHidden: self.manager.hideTools))
            .position(self.currentCenter(proxy))
            .gesture(DragGesture(minimumDistance: 0, coordinateSpace: .named(self.space)).onChanged({self.centerState = $0.translation})
                .onEnded({
                    let x = $0.location.x/proxy.size.width
                    let y = $0.location.y/proxy.size.height
                    
                    self.manager.gradient.center = UnitPoint(x: x, y: y)
                    self.centerState = .zero
                }))
    }
    private var startConfiguration: GradientHandleConfiguration {
        .init(startState != 0, startState != 0, manager.hideTools, Angle(radians: (currentStates.start) * 2 * .pi + .pi/2  ))
    }
    // Creates the startHandle
    private func startHandle(_ proxy: GeometryProxy) ->  some View {
        self.style.makeStartHandle(configuration: startConfiguration)
            .offset(startOffset(proxy))
            .position(currentCenter(proxy))
            .gesture(DragGesture(minimumDistance: 10, coordinateSpace: .named(space))
                .onChanged({
                    let direction = calculateDirection(self.currentCenter(proxy), $0.location)
                    self.startState = direction - self.manager.gradient.startAngle
                })
                .onEnded({
                    self.manager.gradient.startAngle = calculateDirection(self.currentCenter(proxy), $0.location)
                    self.startState = 0
                }))
            .animation(.none)
    }
    private var endConfiguration: GradientHandleConfiguration {
        .init(endState != 0, endState != 0, manager.hideTools, Angle(radians: (currentStates.end) * 2 * .pi + .pi/2  ))
    }
    // Creates the end handle
    private func endHandle(_ proxy: GeometryProxy) ->  some View {
        self.style.makeEndHandle(configuration: endConfiguration)
            .offset(self.endOffset(proxy))
            .position(self.currentCenter(proxy))
            .gesture(DragGesture(minimumDistance: 10, coordinateSpace: .named(space))
                .onChanged({
                    let direction = calculateDirection(self.currentCenter(proxy), $0.location)
                    self.endState = direction - self.manager.gradient.endAngle
                })
                .onEnded({
                    self.manager.gradient.endAngle = calculateDirection(self.currentCenter(proxy), $0.location)
                    self.endState = 0
                }))
            .animation(.none)
    }
    // Creates all stop thumbs
    private func stops(_ proxy: GeometryProxy) -> some View {
        ForEach(self.manager.gradient.stops.indices, id: \.self) { (i) in
            AngularStop(stop: self.$manager.gradient.stops[i],
                        selected: self.$manager.selected,
                        isHidden: self.manager.hideTools,
                        id: self.manager.gradient.stops[i].id,
                        start: self.currentStates.start,
                        end: self.endState + self.manager.gradient.endAngle,
                        center: self.currentCenter(proxy))
            
        }.position(self.currentCenter(proxy))
    }
    
    public var body: some View {
        GeometryReader { proxy in
            ZStack {
                self.gradient(proxy)
                self.center(proxy)
                self.startHandle(proxy)
                self.endHandle(proxy)
                self.stops(proxy)
                
            }.coordinateSpace(name: self.space)
            
        }
    }
}

