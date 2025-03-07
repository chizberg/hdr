//
//  GradientComparisonView.swift
//  hdr
//
//  Created by Alexey Sherstnev on 01.10.2024.
//

import SwiftUI

struct GradientComparisonView: View {
  @State
  private var from = HDRLinearGradientContent.Point(
    color: HDRColor(
      sdrValue: RGBAColor(red: 0, green: 0, blue: 1, alpha: 1),
      extraBrightness: 0
    ),
    position: UnitPoint(x: 0, y: 0)
  )
  
  @State
  private var to = HDRLinearGradientContent.Point(
    color: HDRColor(
      sdrValue: RGBAColor(red: 0, green: 0, blue: 0, alpha: 0),
      extraBrightness: 0
    ),
    position: UnitPoint(x: 0, y: 1)
  )
  
  var body: some View {
    ZStack {
      Color.black.ignoresSafeArea()
      
      VStack {
        Spacer()
        comparison
        Spacer()
        
        HStack {
          controls(for: $from)
          controls(for: $to)
        }.padding()
      }
    }
  }
  
  private var comparison: some View {
    HStack {
      Representable {
        HDRLinearGradientView()
      } updater: { view in
        view.set(
          content: HDRLinearGradientContent(
            from: .init(
              color: from.color,
              position: from.position
            ),
            to: .init(
              color: to.color,
              position: to.position
            )
          )
        )
      }.frame(width: 200, height: 200)
      
      LinearGradient(
        colors: [
          Color(from.color.sdrValue.systemColor),
          Color(to.color.sdrValue.systemColor)
        ],
        startPoint: from.position,
        endPoint: to.position
      ).frame(width: 200, height: 200)
    }
  }
  
  private func controls(
    for point: Binding<HDRLinearGradientContent.Point>
  ) -> some View {
    VStack(spacing: 16) {
      VStack {
        namedSlider("x", value: point.position.x)
        namedSlider("y", value: point.position.y)
      }
      VStack {
        namedSlider("red", value: point.color.sdrValue.red)
        namedSlider("green", value: point.color.sdrValue.green)
        namedSlider("blue", value: point.color.sdrValue.blue)
        namedSlider("alpha", value: point.color.sdrValue.alpha)
      }
      VStack {
        namedSlider("extra", value: point.color.extraBrightness)
      }
    }
  }
}
