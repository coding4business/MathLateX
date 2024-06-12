//
//  CodeEditApp.swift
//  CodeEdit
//
//  Created by Wouter Hennen on 11/03/2023.
//

import CodeEditTextView
import ExtensionKit
import GRDB
import SwiftUI

@main
struct CodeEditApp: App {
  @NSApplicationDelegateAdaptor var appdelegate: AppDelegate
  @ObservedObject var settings = Settings.shared
  @NSApplicationDelegateAdaptor(AppDelegate.self) private var appDelegate
  @AppStorage("showMenuBarExtra") private var showMenuBarExtra = true

  @Environment(\.openWindow)
  var openWindow

  let updater: SoftwareUpdater = SoftwareUpdater()

  init() {
    _ = CodeEditDocumentController.shared
    NSMenuItem.swizzle()
    NSSplitViewItem.swizzle()
  }

  var body: some Scene {

    Group {

      WelcomeWindow()

      ExtensionManagerWindow()

      AboutWindow()

      SettingsWindow()
        .commands {
          CodeEditCommands()
        }
    }
    .environment(\.settings, settings.preferences)
      MathLateXAppMenuBar()
  }
}
