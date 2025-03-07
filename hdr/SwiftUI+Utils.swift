//
//  SwiftUI+Utils.swift
//  hdr
//
//  Created by Alexey Sherstnev on 01.10.2024.
//

import SwiftUI

struct Representable<V: UIView>: UIViewRepresentable {
  private let factory: () -> V
  private let updater: (V) -> Void
  
  init(
    factory: @escaping () -> V,
    updater: @escaping (V) -> Void = { _ in }
  ) {
    self.factory = factory
    self.updater = updater
  }
  
  func makeUIView(context: Context) -> V {
    factory()
  }
  
  func updateUIView(_ view: V, context: Context) {
    updater(view)
  }
}

func namedSlider(
  _ name: String,
  value: Binding<CGFloat>,
  in range: ClosedRange<CGFloat> = 0...1
) -> some View {
  HStack {
    Text(name).font(.caption).foregroundStyle(.white)
      .frame(width: 50, alignment: .leading)
    Slider(value: value, in: range)
  }.padding()
}
