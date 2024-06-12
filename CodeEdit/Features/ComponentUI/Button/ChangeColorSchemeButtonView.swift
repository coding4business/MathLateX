//
//  ChangeColorSchemeButtonView.swift
//  MathLateX
//
//  Created by christian on 08/06/24.
//

import Foundation
import SwiftUI

struct ChangeColorSchemeButtonView: View {
    @State private var showSheet = false
    @State private var action = {}
    @Environment(\.colorScheme) var colorScheme

    init(showSheet: Bool = false, action: () -> Void, colorScheme: ColorScheme) {
        self.showSheet = $showSheet.wrappedValue
        self.action = $action.wrappedValue
    }
  var body: some View {
    VStack {
        Button("Show sheet", systemImage: (self.colorScheme == .dark) ? "moon" : "moon", role: .none, action: {
            action()
        showSheet = true
      })
      .sheet(isPresented: $showSheet) {
        Text("Sheet content")
              .environment(\.colorScheme, colorScheme)
              .preferredColorScheme(.light)
      }
    }.preferredColorScheme(.light)
  }
}
