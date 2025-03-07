//
//  Utils.swift
//  hdr
//
//  Created by Alexey Sherstnev on 30.09.2024.
//

import UIKit

struct RGBAColor {
  var red: CGFloat
  var green: CGFloat
  var blue: CGFloat
  var alpha: CGFloat
}

struct HSBAColor {
  var hue: CGFloat
  var saturation: CGFloat
  var brightness: CGFloat
  var alpha: CGFloat
}

extension RGBAColor {
  var systemColor: UIColor {
    UIColor(red: red, green: green, blue: blue, alpha: alpha)
  }
}

extension RGBAColor {
  init(hsba: HSBAColor) {
    let h = hsba.hue
    let s = hsba.saturation
    let v = hsba.brightness
    
    if s == 0 {
      self.red = v
      self.green = v
      self.blue = v
    } else {
      let sector = h / 60
      let i = floor(sector)
      let f = sector - i
      let p = v * (1 - s)
      let q = v * (1 - s * f)
      let t = v * (1 - s * (1 - f))
      
      switch Int(i) % 6 {
      case 0:
        self.red = v
        self.green = t
        self.blue = p
      case 1:
        self.red = q
        self.green = v
        self.blue = p
      case 2:
        self.red = p
        self.green = v
        self.blue = t
      case 3:
        self.red = p
        self.green = q
        self.blue = v
      case 4:
        self.red = t
        self.green = p
        self.blue = v
      case 5:
        self.red = v
        self.green = p
        self.blue = q
      default:
        self.red = v
        self.green = v
        self.blue = v
      }
    }
    self.alpha = hsba.alpha
  }
}

extension HSBAColor {
  init(rgba: RGBAColor) {
    let r = rgba.red
    let g = rgba.green
    let b = rgba.blue
    let maxVal = max(r, g, b)
    let minVal = min(r, g, b)
    let delta = maxVal - minVal
    
    // Вычисление оттенка
    var hue: CGFloat = 0
    if delta != 0 {
      if maxVal == r {
        hue = 60 * (((g - b) / delta).truncatingRemainder(dividingBy: 6))
      } else if maxVal == g {
        hue = 60 * (((b - r) / delta) + 2)
      } else {
        hue = 60 * (((r - g) / delta) + 4)
      }
      if hue < 0 { hue += 360 }
    }
    
    // Вычисление насыщенности
    let saturation: CGFloat = maxVal != 0 ? delta / maxVal : 0
    
    // Яркость
    let brightness: CGFloat = maxVal
    
    self.init(hue: hue, saturation: saturation, brightness: brightness, alpha: rgba.alpha)
  }
}
