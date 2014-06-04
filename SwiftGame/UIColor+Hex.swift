//
//  UIColor+Hex.swift
//  SwiftGame
//
//  Created by David Sweetman on 6/3/14.
//  Copyright (c) 2014 tinfish. All rights reserved.
//

import UIKit

func colorComponentFrom(string: String, inout #start: String.Index, #end: String.Index) -> Float {
    var range = Range(start: start, end: end)
    var substring = string.substringWithRange(range)
    var hexComponent: CUnsignedInt = 0
    NSScanner.scannerWithString(substring).scanHexInt(&hexComponent)
    // advance the cursor:
    start = end
    return Float(hexComponent) / 255.0
}

extension UIColor {
    convenience init(var hex: String) {
        var red: Float = 0, green: Float = 0, blue: Float = 0, alpha: Float = 1
        hex = hex.stringByReplacingOccurrencesOfString("#", withString: "", options: nil, range: nil)
        var curr = hex.startIndex
        switch countElements(hex) {
        case 3 : // RGB
            red = colorComponentFrom(hex, start: &curr, end: curr.succ())
            green = colorComponentFrom(hex, start: &curr, end: curr.succ())
            blue = colorComponentFrom(hex, start: &curr, end: curr.succ())
        case 4: // #ARGB
            alpha = colorComponentFrom(hex, start: &curr, end: curr.succ())
            red = colorComponentFrom(hex, start: &curr, end: curr.succ())
            green = colorComponentFrom(hex, start: &curr, end: curr.succ())
            blue = colorComponentFrom(hex, start: &curr, end: curr.succ())
        case 6: // #RRGGBB
            red = colorComponentFrom(hex, start: &curr, end: curr.succ().succ())
            green = colorComponentFrom(hex, start: &curr, end: curr.succ().succ())
            blue = colorComponentFrom(hex, start: &curr, end: curr.succ().succ())
        case 8: // #AARRGGBB
            alpha = colorComponentFrom(hex, start: &curr, end: curr.succ().succ())
            red = colorComponentFrom(hex, start: &curr, end: curr.succ().succ())
            green = colorComponentFrom(hex, start: &curr, end: curr.succ().succ())
            blue = colorComponentFrom(hex, start: &curr, end: curr.succ().succ())
        default:
            assert(0 == 1, "Invalid color value", file: "none", line: 0)
        }
        self.init(red: red, green: green, blue: blue, alpha: 1)
    }
}