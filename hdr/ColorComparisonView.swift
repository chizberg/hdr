//
//  ContentView.swift
//  hdr
//
//  Created by Alexey Sherstnev on 30.09.2024.
//

import SwiftUI

struct ColorComparisonView: View {
  @State
  var color = RGBAColor(red: 1, green: 1, blue: 1, alpha: 1)
  @State
  var extraBrightness: CGFloat = 0
  
  var body: some View {
    ZStack {
      Color.black.ignoresSafeArea()
      
      VStack {
        Spacer()
        
        comparison
        
        Spacer()
        
        VStack {
          namedSlider("red", value: $color.red)
          namedSlider("green", value: $color.green)
          namedSlider("blue", value: $color.blue)
          namedSlider("alpha", value: $color.alpha)
          namedSlider("extra", value: $extraBrightness)
        }
        .padding()
      }
    }
  }
  
  private var comparison: some View {
    HStack {
      Representable {
        HDRColorView()
      } updater: { view in
        view.set(color: HDRColor(
          sdrValue: color,
          extraBrightness: extraBrightness
        ))
      }.frame(width: 100, height: 100)
      
      Color(uiColor: color.systemColor)
        .frame(width: 100, height: 100)
    }
  }
}

#Preview {
  ColorComparisonView()
}
