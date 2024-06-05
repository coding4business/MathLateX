//
//  UserProfileMenuPicker.swift
//  CodeEditModules/CodeEditUI
//
//  Created by Lukas Pistrol on 21.04.22.
//

import CodeEditSymbols
import Combine
import SwiftUI

/// A view that pops up a branch picker.
struct UserProfileMenuPicker: View {

  private var user: User

  /// Initializes the ``UserProfileMenuPicker`` with an instance of a `WorkspaceClient`
  /// - Parameter workspace: An instance of the current `WorkspaceClient`
  init(user: User) {
    self.user = user
  }

  var body: some View {
        UserProfileMenu(user: user)
    }
}
