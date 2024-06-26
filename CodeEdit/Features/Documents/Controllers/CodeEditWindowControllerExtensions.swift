//
//  CodeEditWindowControllerExtensions.swift
//  CodeEdit
//
//  Created by Austin Condiff on 10/14/23.
//

import AppKit
import Combine
import Foundation
import SwiftUI

extension CodeEditWindowController {



  @objc
  func toggleSettingsView() {
      WindowCommands().openWindow(sceneID: .settings)
  }

  @objc
  func centeredItemIdentifiers(_ toolbar: NSToolbar) -> Set<NSToolbarItem.Identifier> {
    return Set<NSToolbarItem.Identifier>(arrayLiteral: .print, .cloudSharing, .showFonts, .showColors)
  }

  @objc
  func toggleUserMenu() {

  }
    @objc
    func toggleTheme() {
        self.isDarkMode.toggle()
        
        print(self.isDarkMode)
        print(self.$isDarkMode.wrappedValue)
        print(self.colorScheme)
        print(self.colorScheme)
    }

  @objc
  func toggleFirstPanel() {
    guard let firstSplitView = splitViewController.splitViewItems.first else { return }
    firstSplitView.animator().isCollapsed.toggle()
    if let codeEditSplitVC = splitViewController as? CodeEditSplitViewController {
      codeEditSplitVC.saveNavigatorCollapsedState(isCollapsed: firstSplitView.isCollapsed)
    }
  }

  @objc
  func toggleLastPanel() {
    guard let lastSplitView = splitViewController.splitViewItems.last else { return }
    lastSplitView.animator().isCollapsed.toggle()
    if let codeEditSplitVC = splitViewController as? CodeEditSplitViewController {
      codeEditSplitVC.saveNavigatorCollapsedState(isCollapsed: lastSplitView.isCollapsed)
    }
  }

  func createAddToolbarItem(itemIdentifier: NSToolbarItem.Identifier) -> NSToolbarItem? {
    return NSToolbarItem(itemIdentifier: itemIdentifier)
  }

  /// These are example items that added as commands to command palette
  func registerCommands() {
    CommandManager.shared.addCommand(
      name: "Quick Open",
      title: "Quick Open",
      id: "quick_open",
      command: CommandClosureWrapper(closure: { self.openQuickly(self) })
    )

    CommandManager.shared.addCommand(
      name: "Toggle Settings View",
      title: "Toggle Settings View",
      id: "toggle_setting_view",
      command: CommandClosureWrapper(closure: { self.toggleSettingsView() })
    )

    CommandManager.shared.addCommand(
      name: "Toggle Navigator",
      title: "Toggle Navigator",
      id: "toggle_left_sidebar",
      command: CommandClosureWrapper(closure: { self.toggleFirstPanel() })
    )

    CommandManager.shared.addCommand(
      name: "Toggle Navigator",
      title: "Toggle Navigator",
      id: "toggle_user_menu",
      command: CommandClosureWrapper(closure: { self.toggleUserMenu() })
    )

    CommandManager.shared.addCommand(
      name: "Toggle Inspector",
      title: "Toggle Inspector",
      id: "toggle_right_sidebar",
      command: CommandClosureWrapper(closure: { self.toggleLastPanel() })
    )

      CommandManager.shared.addCommand(
        name: "Toggle Inspector",
        title: "Toggle Inspector",
        id: "toggle_theme",
        command: CommandClosureWrapper(closure: { self.toggleTheme() })
      )

  }

  // Listen to changes in all tabs/files
  internal func listenToDocumentEdited(workspace: WorkspaceDocument) {
    workspace.editorManager.$activeEditor
      .flatMap({ editor in
        editor.$tabs
      })
      .compactMap({ tab in
        Publishers.MergeMany(tab.elements.compactMap({ $0.file.fileDocumentPublisher }))
      })
      .switchToLatest()
      .compactMap({ fileDocument in
        fileDocument?.isDocumentEditedPublisher
      })
      .flatMap({ $0 })
      .sink { isDocumentEdited in
        if isDocumentEdited {
          self.setDocumentEdited(true)
          return
        }

        self.updateDocumentEdited(workspace: workspace)
      }
      .store(in: &cancellables)

    // Listen to change of tabs, if closed tab without saving content,
    // we also need to recalculate isDocumentEdited
    workspace.editorManager.$activeEditor
      .flatMap({ editor in
        editor.$tabs
      })
      .sink { _ in
        self.updateDocumentEdited(workspace: workspace)
      }
      .store(in: &cancellables)
  }

  // Recalculate documentEdited by checking if any tab/file is edited
  private func updateDocumentEdited(workspace: WorkspaceDocument) {
    let hasEditedDocuments = !workspace
      .editorManager
      .editorLayout
      .gatherOpenFiles()
      .filter({ $0.fileDocument?.isDocumentEdited == true })
      .isEmpty
    self.setDocumentEdited(hasEditedDocuments)
  }

  private func insertToolbarItemIfNeeded() {
    guard !(window?.toolbar?.items.contains(where: { $0.itemIdentifier == .branchPicker }) ?? true)
    else {
      return
    }
    window?.toolbar?.insertItem(withItemIdentifier: .branchPicker, at: 4)

  }

  /// Quick fix for list tracking separator needing to be removed after closing the inspector with a drag
  private func removeToolbarItemIfNeeded() {
    guard
      let index = window?.toolbar?.items.firstIndex(
        where: { $0.itemIdentifier == .itemListTrackingSeparator }
      )
    else {
      return
    }
    window?.toolbar?.removeItem(at: index)
  }

  @IBAction func openWorkspaceSettings(_ sender: Any) {
    guard let workspaceSettings, let window = window, let workspace = workspace else {
      return
    }

    if let workspaceSettingsWindow, workspaceSettingsWindow.isVisible {
      workspaceSettingsWindow.makeKeyAndOrderFront(self)
    } else {
      let settingsWindow = NSWindow()
      self.workspaceSettingsWindow = settingsWindow
      let contentView = CEWorkspaceSettingsView(
        settings: workspaceSettings,
        window: settingsWindow,
        workspace: workspace
      )

      settingsWindow.contentView = NSHostingView(rootView: contentView)
      settingsWindow.titlebarAppearsTransparent = true
      settingsWindow.setContentSize(NSSize(width: 515, height: 515))
      settingsWindow.makeKeyAndOrderFront(self)

      window.addCenteredChildWindow(settingsWindow, over: window)
    }
  }
}

extension NSToolbarItem.Identifier {
  static let toggleSettingsSidebarItem: NSToolbarItem.Identifier =
    NSToolbarItem.Identifier("ToggleSettingsSidebarItem")
  static let toggleFirstSidebarItem: NSToolbarItem.Identifier =
    NSToolbarItem.Identifier("ToggleFirstSidebarItem")
  static let toggleLastSidebarItem: NSToolbarItem.Identifier =
    NSToolbarItem.Identifier("ToggleLastSidebarItem")
  static let itemListTrackingSeparator = NSToolbarItem.Identifier("ItemListTrackingSeparator")
  static let branchPicker: NSToolbarItem.Identifier = NSToolbarItem.Identifier("BranchPicker")
  static let toggleUserMenu: NSToolbarItem.Identifier = NSToolbarItem.Identifier("ToggleUserMenu")
    static let toggleTheme: NSToolbarItem.Identifier = NSToolbarItem.Identifier("ToggleTheme")
  static let firstSidebarToolbarItems: [NSToolbarItem.Identifier] = [
    NSToolbarItem.Identifier("ToggleUserMenu")
  ]
  static let middleToolbarItems: [NSToolbarItem.Identifier] = [
    NSToolbarItem.Identifier("ToggleUserMenu")
  ]
  static let lastSidebarToolbarItem: [NSToolbarItem.Identifier] = [
    NSToolbarItem.Identifier("ToggleUserMenu")
  ]
}
