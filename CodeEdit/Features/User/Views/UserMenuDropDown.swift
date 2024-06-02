//
//  UserMenuDropDown.swift
//  MathLateX
//
//  Created by christian on 31/05/24.
//

import SwiftUI

struct UserMenuDropDown: View {
  // swiftlint: disable redundant_optional_initialization superfluous_disable_command
  @State var selection: String?
  // swiftlint: enable redundant_optional_initialization superfluous_disable_command

  var body: some View {
    UserDropDownPicker(
      selection: $selection,
      options: [
        "Apple",
        "Google",
        "Amazon",
        "Facebook",
        "Instagram",
      ]
    )
  }
}

#Preview {
  UserMenuDropDown()
}
