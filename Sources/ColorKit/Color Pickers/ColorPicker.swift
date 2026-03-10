//
//  ColorPicker.swift
//  MyExamples
//
//  Created by Kieran Brown on 4/7/20.
//  Copyright © 2020 BrownandSons. All rights reserved.
//

import SwiftUI

public struct ColorPickerButton: ButtonStyle {
    public func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .foregroundColor(configuration.isPressed ? .white : .blue)
            .frame(width: 20, height: 20)
            .padding()
            .background(
                Group {
                    if configuration.isPressed {
                        RoundedRectangle(cornerRadius: 5)
                            .fill(Color.blue)
                    } else {
                        RoundedRectangle(cornerRadius: 5)
                            .stroke(Color.blue)
                    }
                }
            )
    }
}

public struct ColorPicker: View {
    @ObservedObject public var manager: ColorManager
    
    public init(_ manager: ObservedObject<ColorManager>) {
        self._manager = manager
    }
    
    private var colors: [ColorToken] {
        Array(manager.colors.values).sorted(by: {$0.dateCreated > $1.dateCreated})
    }
    
    private var selectedColor: Binding<ColorToken> {
        Binding(get: {
            if manager.selected == nil {
                return manager.defaultColor
            } else {
                return manager.colors[manager.selected!]!
            }
        }) {
            if manager.selected == nil {
                manager.defaultColor = $0
            } else {
                manager.colors[manager.selected!]! = $0
            }
        }
    }
    
    private func select(_ id: UUID) {
        if manager.selected == id {
            manager.selected = nil
        } else {
            manager.selected = id
        }
    }
    
    private var pallette: some View {
        ScrollView(.horizontal, showsIndicators: true) {
            HStack(spacing: 0) {
                ForEach(colors) { (color)  in
                    Rectangle()
                        .fill(color.color)
                        .frame(width: 50, height: 50)
                        .onTapGesture {
                            select(color.id)
                        }
                        .border(manager.selected == color.id ? Color.blue : Color.clear)
                }
            }
        }
    }
    
    private var formulationPicker: some View {
        Picker(selection: selectedColor.colorFormulation, label: Text("Color Formulation")) {
            ForEach(ColorToken.ColorFormulation.allCases) { (formulation)  in
                Text(formulation.rawValue).tag(formulation)
            }
        }
        .pickerStyle(SegmentedPickerStyle())
    }
    
    private var rgbColorSpacePicker: some View {
        Picker(selection: selectedColor.rgbColorSpace, label: Text("")) {
            ForEach(ColorToken.RGBColorSpace.allCases) { space in
                Text(space.rawValue).tag(space)
            }
        }
        .pickerStyle(SegmentedPickerStyle())
    }
    
    private var rgbPicker: some View {
        VStack {
            rgbColorSpacePicker
            Spacer()
            RGBColorPicker(selectedColor)
        }
        .padding(.vertical, 10)
    }
    
    private var hsbPicker: some View {
        HSBColorPicker(selectedColor)
    }
    
    private var currentColorPicker: some View {
        Group {
            if selectedColor.colorFormulation.wrappedValue == .rgb {
                rgbPicker
            } else if selectedColor.colorFormulation.wrappedValue == .hsb {
                hsbPicker
            } else if selectedColor.colorFormulation.wrappedValue == .cmyk {
                CMYKColorPicker(selectedColor)
            } else if selectedColor.colorFormulation.wrappedValue == .gray {
                GrayScaleSlider(selectedColor)
                    .frame(height: 40)
            }
        }
        .frame(height: 300)
    }
    
    private var buttons: some View {
        HStack {
            Button(action: manager.delete) {
                Image(systemName: "xmark")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
            }
            
            Button(action: manager.add) {
                Image(systemName: "plus")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
            }
        }
        .frame(height: 30)
    }
    
    public var body: some View {
        VStack {
            RoundedRectangle(cornerRadius: 5)
                .fill(selectedColor.wrappedValue.color)
            pallette
            formulationPicker
            currentColorPicker
            AlphaSlider(selectedColor)
                .frame(height: 40)
                .padding(.bottom, 10)
            buttons
        }
        .padding(.horizontal, 40)
    }
}

