//
//  HDRColor.swift
//  hdr
//
//  Created by Alexey Sherstnev on 30.09.2024.
//

import Foundation

struct HDRColor {
  var sdrValue: RGBAColor
  var extraBrightness: CGFloat
  
  var hdrValue: RGBAColor { // using HSB, should probably cache it
    var hsba = HSBAColor(rgba: sdrValue)
    hsba.brightness += extraBrightness
    return RGBAColor(hsba: hsba)
  }
}

extension HDRColor {
  var hdrSimd4: SIMD4<Float> {
    SIMD4(
      Float(hdrValue.red),
      Float(hdrValue.green),
      Float(hdrValue.blue),
      Float(hdrValue.alpha)
    )
  }
}
