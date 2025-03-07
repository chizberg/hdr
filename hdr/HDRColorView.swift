//
//  HDRColorView.swift
//  hdr
//
//  Created by Alexey Sherstnev on 30.09.2024.
//

import Metal
import UIKit

struct HDRColorContent: HDRContent {
  var value: HDRColor
  
  func fill(encoder: any MTLComputeCommandEncoder) {
    encoder.set(value: value.hdrSimd4, index: 0)
  }
  
  static let shaderName = "drawColor"
}

typealias HDRColorView = HDRView<HDRColorContent>

extension HDRColorView {
  func set(color: HDRColor) {
    set(content: HDRColorContent(value: color))
  }
}
