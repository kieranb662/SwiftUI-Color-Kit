//
//  ColorPicker.swift
//  MyExamples
//
//  Created by Kieran Brown on 4/7/20.
//  Copyright © 2020 BrownandSons. All rights reserved.
//

import SwiftUI

@available(iOS 13.0, macOS 10.15, watchOS 6.0 , *)
struct ColorPickerButton: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
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
struct ColorPicker: View {
    @ObservedObject var manager: ColorManager
  
    var colors: [ColorToken] {
        Array(self.manager.colors.values).sorted(by: {$0.dateCreated > $1.dateCreated})
    }
    
    var selectedColor: Binding<ColorToken> {
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
    
    func select(_ id: UUID) {
        if self.manager.selected == id {
            self.manager.selected = nil
        } else {
            self.manager.selected = id
        }
    }
    var pallette: some View {
        ScrollView(.horizontal, showsIndicators: true) {
            HStack(spacing: 0) {
                ForEach(self.colors) { (color)  in
                    Rectangle()
                        .fill(color.color)
                        .frame(width: 50, height: 50)
                        .onTapGesture {
                            self.select(color.id)
                    }
                }
            }
        }
    }
    var formulationPicker: some View {
        Picker(selection: self.selectedColor.colorFormulation, label: Text("Color Formulation")) {
            ForEach(ColorToken.ColorFormulation.allCases) { (formulation)  in
                Text(formulation.rawValue).tag(formulation)
            }
        }.pickerStyle(SegmentedPickerStyle())
    }
    var rgbColorSpacePicker: some View {
        Picker(selection: self.selectedColor.rgbColorSpace, label: Text("")) {
            ForEach(ColorToken.RGBColorSpace.allCases) { space in
                Text(space.rawValue).tag(space)
            }
        }.pickerStyle(SegmentedPickerStyle())
    }
    var rgbPicker: some View {
        VStack {
            rgbColorSpacePicker
            Spacer()
            RGBColorPicker(color: self.selectedColor)
        }.padding(.vertical, 10)
    }
    var hsbPicker: some View {
        HSBColorPicker(color: self.selectedColor)
    }
    var currentColorPicker: some View {
        Group {
            if self.selectedColor.colorFormulation.wrappedValue == .rgb {
                rgbPicker
            } else if self.selectedColor.colorFormulation.wrappedValue == .hsb {
                hsbPicker
            } else if self.selectedColor.colorFormulation.wrappedValue == .cmyk {
                CMYKColorPicker(self.selectedColor)
            } else if self.selectedColor.colorFormulation.wrappedValue == .gray {
                GrayScaleSlider(color: self.selectedColor).frame(height: 40)
            }
        }.frame(height: 300)
    }
    var buttons: some View {
        HStack {
            Button(action: self.manager.delete, label: {Image(systemName: "xmark").resizable().aspectRatio(contentMode: .fit)})
            Button(action: self.manager.add, label: {Image(systemName: "plus").resizable().aspectRatio(contentMode: .fit)})
        }
    }
    
    var body: some View {
        VStack {
            RoundedRectangle(cornerRadius: 5)
                .fill(self.selectedColor.wrappedValue.color)
            pallette
            formulationPicker
            currentColorPicker
            AlphaSlider(color: self.selectedColor)
                .frame(height: 40)
                .padding(.bottom, 10)
            buttons
        }.padding(.horizontal, 40)
    }
}

