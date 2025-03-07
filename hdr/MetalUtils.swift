//
//  MetalUtils.swift
//  hdr
//
//  Created by Alexey Sherstnev on 30.09.2024.
//

import QuartzCore

func calculateOptimalThreadgroupAndGridSize(
  for pipelineState: MTLComputePipelineState,
  texture: MTLTexture
) -> (threadgroupsPerGrid: MTLSize, threadsPerThreadgroup: MTLSize) {
  // Use the pipeline state's threadExecutionWidth as the threadgroup width.
  let executionWidth = pipelineState.threadExecutionWidth
  
  // Calculate the threadgroup height so that the total threads do not exceed the maximum allowed.
  let threadgroupHeight = pipelineState.maxTotalThreadsPerThreadgroup / executionWidth
  
  // Create the threads-per-threadgroup size.
  let threadsPerThreadgroup = MTLSize(width: executionWidth,
                                      height: threadgroupHeight,
                                      depth: 1)
  
  // For dispatchThreadgroups, round up so that every pixel is covered.
  let threadgroupsPerGrid = MTLSize(
    width: (texture.width + executionWidth - 1) / executionWidth,
    height: (texture.height + threadgroupHeight - 1) / threadgroupHeight,
    depth: 1
  )
  
  return (threadgroupsPerGrid, threadsPerThreadgroup)
}

extension MTLComputeCommandEncoder {
  func set<T>(value: T, index: Int) {
    precondition(_isPOD(T.self))
    withUnsafeBytes(of: value) {
      setBytes($0.baseAddress!, length: MemoryLayout<T>.stride, index: index)
    }
  }
}

protocol MetalRenderSurface {
  func render(with: MetalRenderer)
  var preferredDevice: MTLDevice? { get }
}

typealias CALayerMetalSurface = CALayer & MetalRenderSurface

protocol MetalRenderer {
  var device: MTLDevice? { get }
  
  func render(
    on texture: MTLTexture,
    onFinish: (MTLCommandBuffer) -> Void
  )
}

final class CAMetalRenderSurface: CAMetalLayer, MetalRenderSurface {
  override init() {
    super.init()
    framebufferOnly = false
  }
  
  override init(layer: Any) {
    super.init(layer: layer)
  }
  
  required init?(coder: NSCoder) {
    super.init(coder: coder)
  }
  
  override var preferredDevice: MTLDevice? {
    super.preferredDevice ?? self.device ?? MTLCreateSystemDefaultDevice()
  }
  
  func render(with renderer: MetalRenderer) {
    autoreleasepool {
      guard let drawable = nextDrawable() else { return }
      renderer.render(on: drawable.texture) { cmdBuffer in
        cmdBuffer.present(drawable)
        cmdBuffer.commit()
      }
    }
  }
}
