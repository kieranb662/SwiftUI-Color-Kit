//
//  ColorPicker.swift
//  MyExamples
//
//  Created by Kieran Brown on 4/7/20.
//  Copyright © 2020 BrownandSons. All rights reserved.
//

import SwiftUI

@available(iOS 13.0, macOS 10.15, watchOS 6.0 , *)
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
            })
    }
}


@available(iOS 13.0, macOS 10.15, watchOS 6.0 , *)
public struct ColorPicker: View {
    @ObservedObject public var manager: ColorManager
    public init(_ manager: ObservedObject<ColorManager>) {
        self._manager = manager
    }
  
    private var colors: [ColorToken] {
        Array(self.manager.colors.values).sorted(by: {$0.dateCreated > $1.dateCreated})
    }
    
    private var selectedColor: Binding<ColorToken> {
        Binding(get: {
            if self.manager.selected == nil {
                return self.manager.defaultColor
            } else {
                return self.manager.colors[self.manager.selected!]!
            }
        }) {
            if self.manager.selected == nil {
                self.manager.defaultColor = $0
            } else {
                self.manager.colors[self.manager.selected!]! = $0
            }
        }
    }
    
    private func select(_ id: UUID) {
        if self.manager.selected == id {
            self.manager.selected = nil
        } else {
            self.manager.selected = id
        }
    }
    private var pallette: some View {
        ScrollView(.horizontal, showsIndicators: true) {
            HStack(spacing: 0) {
                ForEach(self.colors) { (color)  in
                    Rectangle()
                        .fill(color.color)
                        .frame(width: 50, height: 50)
                        .onTapGesture {
                            self.select(color.id)
                    }.border(self.manager.selected == color.id ? Color.blue : Color.clear)
                }
            }
        }
    }
    private var formulationPicker: some View {
        Picker(selection: self.selectedColor.colorFormulation, label: Text("Color Formulation")) {
            ForEach(ColorToken.ColorFormulation.allCases) { (formulation)  in
                Text(formulation.rawValue).tag(formulation)
            }
        }.pickerStyle(SegmentedPickerStyle())
    }
    private var rgbColorSpacePicker: some View {
        Picker(selection: self.selectedColor.rgbColorSpace, label: Text("")) {
            ForEach(ColorToken.RGBColorSpace.allCases) { space in
                Text(space.rawValue).tag(space)
            }
        }.pickerStyle(SegmentedPickerStyle())
    }
    private var rgbPicker: some View {
        VStack {
            rgbColorSpacePicker
            Spacer()
            RGBColorPicker(self.selectedColor)
        }.padding(.vertical, 10)
    }
    private var hsbPicker: some View {
        HSBColorPicker(self.selectedColor)
    }
    private var currentColorPicker: some View {
        Group {
            if self.selectedColor.colorFormulation.wrappedValue == .rgb {
                rgbPicker
            } else if self.selectedColor.colorFormulation.wrappedValue == .hsb {
                hsbPicker
            } else if self.selectedColor.colorFormulation.wrappedValue == .cmyk {
                CMYKColorPicker(self.selectedColor)
            } else if self.selectedColor.colorFormulation.wrappedValue == .gray {
                GrayScaleSlider(self.selectedColor)
                    .frame(height: 40)
            }
        }.frame(height: 300)
    }
    private var buttons: some View {
        HStack {
            Button(action: self.manager.delete, label: {
                Image(systemName: "xmark")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                
            })
            Button(action: self.manager.add, label: {
                Image(systemName: "plus")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                
            })
        }.frame(height: 30)
    }
    
    public var body: some View {
        VStack {
            RoundedRectangle(cornerRadius: 5)
                .fill(self.selectedColor.wrappedValue.color)
            pallette
            formulationPicker
            currentColorPicker
            AlphaSlider(self.selectedColor)
                .frame(height: 40)
                .padding(.bottom, 10)
            buttons
        }.padding(.horizontal, 40)
    }
}

