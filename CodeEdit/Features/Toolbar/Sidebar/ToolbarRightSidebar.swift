//
//  ToolbarRightSidebar.swift
//  MathLateX
//
//  Created by christian on 31/05/24.
//

import SwiftUI

struct ToolbarRightSidebar: View {
  @State var isShowingPopover = false

  var body: some View {
    EmptyView()
      .toolbar {
          ToolbarItem(placement: .status) {
              Button("Popover") {

              }
          Button("Popover") {
            isShowingPopover.toggle()
          }
          .popover(isPresented: $isShowingPopover) {
            Text("Hi from a popover")
              .padding()
              .frame(width: 320, height: 100)
          }
        }

      }
  }
}
