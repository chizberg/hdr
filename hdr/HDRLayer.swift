//
//  HDRLayer.swift
//  hdr
//
//  Created by Alexey Sherstnev on 30.09.2024.
//

import UIKit
import Metal

protocol HDRContent {
  func fill(encoder: MTLComputeCommandEncoder)
  static var shaderName: String { get }
}

final class HDRLayer<Content: HDRContent>: CALayer {
  private let renderingSublayer: CAMetalRenderSurface
  private let renderer: HDRRenderer<Content>
  
  override init() {
    let renderingSublayer = CAMetalRenderSurface()
    self.renderingSublayer = renderingSublayer
    renderer = HDRRenderer(device: renderingSublayer.preferredDevice)
    super.init()
    configureRenderingSublayer()
  }
  
  override init(layer: Any) {
    let hdrLayer = layer as? HDRLayer<Content>
    renderingSublayer = hdrLayer?.renderingSublayer ?? CAMetalRenderSurface()
    renderer = hdrLayer?.renderer ?? HDRRenderer(device: renderingSublayer.preferredDevice)
    super.init(layer: layer)
    configureRenderingSublayer()
  }
  
  @available(*, unavailable)
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func display() {
    renderingSublayer.render(with: renderer)
  }
  
  override func layoutSublayers() {
    super.layoutSublayers()
    renderingSublayer.frame = bounds
    setNeedsDisplay()
  }
  
  func set(content: Content) {
    renderer.content = content
    setNeedsDisplay()
  }
  
  private func configureRenderingSublayer() {
    renderingSublayer.pixelFormat = .rgba16Float
    renderingSublayer.wantsExtendedDynamicRangeContent = true
    renderingSublayer.isOpaque = false
    addSublayer(renderingSublayer)
  }
}

private final class HDRRenderer<Content: HDRContent>: MetalRenderer {
  let device: MTLDevice?
  var content: Content?
  private let commandQueue: MTLCommandQueue?
  private let pipelineState: MTLComputePipelineState?
  
  init(
    device: MTLDevice?
  ) {
    self.device = device
    self.commandQueue = device?.makeCommandQueue()
    self.pipelineState = device.flatMap {
      guard let drawFunction = makeDrawFunction(
        device: $0, shaderName: Content.shaderName
      ) else {
        return nil
      }
      return try? $0.makeComputePipelineState(function: drawFunction)
    }
  }
  
  func render(
    on texture: any MTLTexture,
    onFinish: (any MTLCommandBuffer) -> Void
  ) {
    guard let pipelineState = pipelineState,
          let commandBuffer = commandQueue?.makeCommandBuffer(),
          let commandEncoder = commandBuffer.makeComputeCommandEncoder()
    else {
      return assertionFailure()
    }
    let (threadgroupsPerGrid, threadsPerThreadgroup) =
    calculateOptimalThreadgroupAndGridSize(for: pipelineState, texture: texture)
    commandEncoder.setComputePipelineState(pipelineState)
    content?.fill(encoder: commandEncoder)
    commandEncoder.setTexture(texture, index: 0)
    commandEncoder.dispatchThreadgroups(
      threadgroupsPerGrid,
      threadsPerThreadgroup: threadsPerThreadgroup
    )
    commandEncoder.endEncoding()
    onFinish(commandBuffer)
  }
}

private func makeDrawFunction(device: MTLDevice, shaderName: String) -> MTLFunction? {
  let library = device.makeDefaultLibrary()
  return library?.makeFunction(name: shaderName)
}
