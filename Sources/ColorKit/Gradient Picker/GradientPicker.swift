//
//  GradientPicker.swift
//  MyExamples
//
//  Created by Kieran Brown on 4/6/20.
//  Copyright © 2020 BrownandSons. All rights reserved.
//

import SwiftUI




// MARK: Gradient Manager
@available(iOS 13.0, macOS 10.15, watchOS 6.0 , *)
public class GradientManager: ObservableObject {
    @Published public var gradient: GradientData
    @Published public var hideTools: Bool = false
    /// The currently selected stop if one is selected
    @Published public var selected: UUID? = nil 
    
    public init(_ gradient: GradientData) {
        self.gradient = gradient
    }
}

/// Example of using all three of the gradient pickers to make a single unified picker
/// Does not have a color picker associated with so one must implement this as part of a larger view with a colorpicker 
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
        HStack {
            Text("Gradient").frame(width: 80)
            Picker("Gradient", selection: $manager.gradient.type) {
                ForEach(GradientData.GradientType.allCases, id: \.self) { (type) in
                    Text(type.rawValue).tag(type)
                }
            }.pickerStyle(SegmentedPickerStyle())
        }
    }
    private var renderModePicker: some View {
        HStack {
            Text("Render Mode").frame(width: 80)
            Picker("Render Mode", selection: $manager.gradient.renderMode) {
                ForEach(GradientData.ColorRenderMode.allCases, id: \.self) { (type) in
                    Text(type.rawValue).tag(type)
                }
            }.pickerStyle(SegmentedPickerStyle())
        }
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
            typePicker.padding(.horizontal, 40)
            renderModePicker.padding(.horizontal, 40)
            toolToggle.padding(.horizontal, 40)
            currentPicker
                .frame(idealHeight: 400, maxHeight: 500)
                .padding(35)
        }
    }
}


