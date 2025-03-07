//
//  HDRView.swift
//  hdr
//
//  Created by Alexey Sherstnev on 30.09.2024.
//

import UIKit

final class HDRView<Content: HDRContent>: UIView {
  private let contentLayer: HDRLayer<Content>
  
  init() {
    contentLayer = HDRLayer()
    super.init(frame: .zero)
    
    layer.addSublayer(contentLayer)
  }
  
  func set(content: Content) {
    contentLayer.set(content: content)
  }
  
  @available(*, unavailable)
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func layoutSubviews() {
    super.layoutSubviews()
    contentLayer.frame = bounds
  }
}

