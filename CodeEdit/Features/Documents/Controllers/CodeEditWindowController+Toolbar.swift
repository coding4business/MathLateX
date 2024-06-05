//
//  CodeEditWindowController+Toolbar.swift
//  CodeEdit
//
//  Created by Daniel Zhu on 5/10/24.
//

import SwiftUI

extension CodeEditWindowController {

  internal func setupToolbar() {
    let toolbar = NSToolbar(identifier: UUID().uuidString)
    toolbar.delegate = self
    toolbar.displayMode = .iconOnly
    toolbar.showsBaselineSeparator = false
    self.window?.titleVisibility = toolbarCollapsed ? .visible : .hidden
    self.window?.toolbarStyle = .unified
    if Settings[\.general].tabBarStyle == .native {
      // Set titlebar background as transparent by default in order to
      // style the toolbar background in native tab bar style.
      self.window?.titlebarSeparatorStyle = .shadow
    } else {
      // In Xcode tab bar style, we use default toolbar background with
      // line separator.
      self.window?.titlebarSeparatorStyle = .automatic
    }
    toolbar.allowsExtensionItems = true
    toolbar.allowsUserCustomization = true
    self.window?.toolbar = toolbar
  }

  func toolbarDefaultItemIdentifiers(_ toolbar: NSToolbar) -> [NSToolbarItem.Identifier] {
    [
      .toggleSettingsSidebarItem,
      .toggleSettingsSidebarItem,
      .toggleSettingsSidebarItem,
      .toggleSettingsSidebarItem,
      .sidebarTrackingSeparator,
      .toggleFirstSidebarItem,
      .branchPicker,
      .flexibleSpace,
      .toggleSettingsSidebarItem,
      .toggleSettingsSidebarItem,
      .toggleSettingsSidebarItem,
      .toggleSettingsSidebarItem,
      .flexibleSpace,
      .toggleSettingsSidebarItem,
      .toggleSettingsSidebarItem,
      .toggleSettingsSidebarItem,
      .toggleSettingsSidebarItem,
      .flexibleSpace,
      .toggleLastSidebarItem,
      .itemListTrackingSeparator,
      .flexibleSpace,
      .toggleUserMenu,
    ]
  }

  func toolbarAllowedItemIdentifiers(_ toolbar: NSToolbar) -> [NSToolbarItem.Identifier] {
    [
      .toggleSettingsSidebarItem,
      .toggleSettingsSidebarItem,
      .toggleSettingsSidebarItem,
      .toggleSettingsSidebarItem,
      .sidebarTrackingSeparator,
      .toggleFirstSidebarItem,
      .branchPicker,
      .flexibleSpace,
      .toggleSettingsSidebarItem,
      .toggleSettingsSidebarItem,
      .toggleSettingsSidebarItem,
      .toggleSettingsSidebarItem,
      .flexibleSpace,
      .toggleSettingsSidebarItem,
      .toggleSettingsSidebarItem,
      .toggleSettingsSidebarItem,
      .toggleSettingsSidebarItem,
      .flexibleSpace,
      .toggleLastSidebarItem,
      .itemListTrackingSeparator,
      .flexibleSpace,
      .toggleUserMenu,
    ]
  }

  func toggleToolbar() {
    toolbarCollapsed.toggle()
    updateToolbarVisibility()
  }

  private func updateToolbarVisibility() {
    if toolbarCollapsed {
      window?.titleVisibility = .visible
      window?.title = workspace?.workspaceFileManager?.folderUrl.lastPathComponent ?? "Empty"
      window?.toolbar = nil
    } else {
      window?.titleVisibility = .hidden
      setupToolbar()
    }
  }

  private func setToolbarItemProperties(
    toolbarItem: NSToolbarItem, view: NSView?, label: String, paletteLabel: String?,
    tooltip: String?, isBordered: Bool, target: AnyObject?, action: Selector?
  ) {
    toolbarItem.view = view
    toolbarItem.label = label
    toolbarItem.paletteLabel = paletteLabel!
    toolbarItem.toolTip = tooltip
    toolbarItem.isBordered = isBordered
    toolbarItem.target = target
    toolbarItem.action = action
  }

  private func insertToolbarItemIfNeeded() {
    guard
      !(window?.toolbar?.items.contains(where: { $0.itemIdentifier == .branchPicker }) ?? true)
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

  func toolbar(
    _ toolbar: NSToolbar,
    itemForItemIdentifier itemIdentifier: NSToolbarItem.Identifier,
    willBeInsertedIntoToolbar flag: Bool
  ) -> NSToolbarItem? {
    switch itemIdentifier {
    case .toggleSettingsSidebarItem:
      let toolbarItem = NSToolbarItem(
        itemIdentifier: NSToolbarItem.Identifier.toggleSettingsSidebarItem)
      toolbarItem.image = NSImage(
        systemSymbolName: "gear",
        accessibilityDescription: nil
      )?.withSymbolConfiguration(.init(scale: .large))
      toolbarItem.label = "Navigator Sidebar"
      toolbarItem.paletteLabel = " Navigator Sidebar"
      toolbarItem.toolTip = "Hide or show the Navigator"
      toolbarItem.isBordered = true
      toolbarItem.target = self
      toolbarItem.action = #selector(self.toggleSettingsView)
      return toolbarItem
    case .toggleFirstSidebarItem:
            let toolbarItem = SwiftUI.NSToolbarItem(
        itemIdentifier: NSToolbarItem.Identifier.toggleFirstSidebarItem)
            toolbarItem.image = NSImage(
        systemSymbolName: "sidebar.leading",
        accessibilityDescription: nil
            )?.withSymbolConfiguration(.init(scale: .large))
            toolbarItem.image!.size = .init(width: 48, height: 48)
            toolbarItem.view?.frame.size = .init(width: 48, height: 48)
            toolbarItem.view?.frame.fill()
      toolbarItem.label = "Navigator Sidebar"
      toolbarItem.paletteLabel = " Navigator Sidebar"
      toolbarItem.toolTip = "Hide or show the Navigator"
      toolbarItem.isBordered = true
      toolbarItem.target = self
      toolbarItem.action = #selector(self.toggleFirstPanel)
      return toolbarItem
    case .toggleLastSidebarItem:
      let toolbarItem = NSToolbarItem(
        itemIdentifier: NSToolbarItem.Identifier.toggleLastSidebarItem)
      toolbarItem.label = "Inspector Sidebar"
      toolbarItem.paletteLabel = "Inspector Sidebar"
      toolbarItem.toolTip = "Hide or show the Inspectors"
      toolbarItem.isBordered = true
      toolbarItem.target = self
      toolbarItem.action = #selector(self.toggleLastPanel)
      toolbarItem.image = NSImage(
        systemSymbolName: "sidebar.trailing",
        accessibilityDescription: nil
      )?.withSymbolConfiguration(.init(scale: .large))
      return toolbarItem
    case .itemListTrackingSeparator:
      let toolbarItem = NSToolbarItem(
        itemIdentifier: NSToolbarItem.Identifier.itemListTrackingSeparator)
      guard let splitViewController else { return nil }
      return NSTrackingSeparatorToolbarItem(
        identifier: .itemListTrackingSeparator,
        splitView: splitViewController.splitView,
        dividerIndex: 1
      )
    case .toggleUserMenu:
      let user = User(
        login: "ai-coded",
        name: "ai-coded",
        avatarURLString: "https://avatars.githubusercontent.com/u/83773748?v=4",
        profile: "https://github.com/ai-coded",
        users: [.infra, .test, .code]
      )
      let toolbarItem = NSToolbarItem(itemIdentifier: .toggleUserMenu)
      let hostingView = NSHostingView(
        rootView: UserProfileMenuPicker(user: user)
      )
      setToolbarItemProperties(
        toolbarItem: toolbarItem, view: hostingView, label: user.name,
        paletteLabel: user.name, tooltip: user.name, isBordered: true,
        target: self, action: #selector(self.toggleUserMenu))
      return toolbarItem
    case .branchPicker:
      let toolbarItem = NSToolbarItem(itemIdentifier: .branchPicker)
      let hostingView = NSHostingView(
        rootView: ToolbarBranchPicker(
          workspaceFileManager: workspace?.workspaceFileManager
        )
      )
      toolbarItem.view = hostingView
      return toolbarItem
    default:
      return NSToolbarItem(itemIdentifier: itemIdentifier)
    }
  }
}
