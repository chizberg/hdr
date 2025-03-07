//
//  HDRLinearGradientView.swift
//  hdr
//
//  Created by Alexey Sherstnev on 30.09.2024.
//

import Metal
import SwiftUI

struct HDRLinearGradientContent: HDRContent {
  struct Point {
    var color: HDRColor
    var position: UnitPoint
  }
  
  var from: Point
  var to: Point
  
  func fill(encoder: any MTLComputeCommandEncoder) {
    encoder.set(value: from.color.hdrSimd4, index: 0)
    encoder.set(value: from.position.simd2, index: 1)
    encoder.set(value: to.color.hdrSimd4, index: 2)
    encoder.set(value: to.position.simd2, index: 3)
  }
  
  static let shaderName = "drawLinearGradient"
}

typealias HDRLinearGradientView = HDRView<HDRLinearGradientContent>

extension UnitPoint {
  var simd2: SIMD2<Float> {
    SIMD2(
      Float(x),
      Float(y)
    )
  }
}
