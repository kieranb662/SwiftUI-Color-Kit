//
//  PlatformColor.swift
//  
//
//  Created by Kieran Brown on 4/13/20.
//

#if os(iOS) || os(tvOS)
import UIKit
public typealias PlatformColor = UIColor
#else
import AppKit
public typealias PlatformColor = NSColor
#endif


extension PlatformColor {
    
    convenience init(cmyk: (c: CGFloat, m: CGFloat, y: CGFloat, k: CGFloat)) {
        let cmyTransform = { x in
            return x * (1 - cmyk.k) + cmyk.k
        }
        let C = cmyTransform(cmyk.c)
        let M = cmyTransform(cmyk.m)
        let Y = cmyTransform(cmyk.y)
        self.init(red: 1-C, green: 1-M, blue: 1-Y, alpha: 1)
        
    }
}
