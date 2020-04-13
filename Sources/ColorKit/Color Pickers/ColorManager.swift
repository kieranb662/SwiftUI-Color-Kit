//
//  File.swift
//  
//
//  Created by Kieran Brown on 4/12/20.
//

import SwiftUI

@available(iOS 13.0, macOS 10.15, watchOS 6.0 , *)
public class ColorManager: ObservableObject {
    @Published public var colors: [UUID: ColorToken]
    @Published public var selected: UUID?
    @Published public var defaultColor: ColorToken = .init(r: 0.5, g: 0.5, b: 0.5)
    
    public func add() {
        let new: ColorToken = {
            switch defaultColor.colorFormulation {
            case .rgb: return ColorToken(name: defaultColor.name, colorSpace: defaultColor.rgbColorSpace, r: defaultColor.red, g: defaultColor.green, b: defaultColor.blue, a: defaultColor.alpha)
            case .hsb: return ColorToken(name: defaultColor.name, hue: defaultColor.hue, saturation: defaultColor.saturation, brightness: defaultColor.brightness, opacity: defaultColor.alpha)
            case .cmyk: return ColorToken(name: defaultColor.name, cyan: defaultColor.cyan, magenta: defaultColor.magenta, yellow: defaultColor.yellow, keyBlack: defaultColor.keyBlack)
            case .gray: return ColorToken(name: defaultColor.name, white: defaultColor.white, opacity: defaultColor.alpha)
            }
        }()
        colors[new.id] = new
    }
    
    
    public func delete() {
        if selected != nil {
            let temp = selected
            selected = nil
            self.colors.removeValue(forKey: temp!)
        }
    }
    
    public init(colors: [ColorToken]) {
        
        self.colors = [:]
        colors.forEach {
            self.colors[$0.id] = $0
        }
    }
}
