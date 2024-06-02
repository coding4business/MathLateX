// swiftlint: disable all
//  UserDropDownPicker.swift
//  MathLateX
//
//  Created by christian on 31/05/24.
//

import SwiftUI

struct UserDropDownPicker: View {

  @Binding var selection: String?
    var state: DropDownPickerState = .bottom
  var options: [String]
  var maxWidth: CGFloat = 180

  @State var showDropdown = false

  @SceneStorage("drop_down_zindex") private var index = 1000.0
  @State var zindex = 1000.0

  var body: some View {
    GeometryReader {
      let size = $0.size
        Menu("") {
            VStack(spacing: 0) {

                if state == .top && showDropdown {
                    OptionsView()
                }

                HStack {
                    Text(selection == nil ? "Select" : selection!)
                        .foregroundColor(selection != nil ? .black : .gray)

                    Spacer(minLength: 0)

                    Image(systemName: state == .top ? "chevron.up" : "chevron.down")
                        .font(.title3)
                        .foregroundColor(.gray)
                        .rotationEffect(.degrees((showDropdown ? -180 : 0)))
                }
                .padding(.horizontal, 15)
                .frame(width: 180, height: 50)
                .background(.white)
                .contentShape(.rect)
                .onTapGesture {
                    index += 1
                    zindex = index
                    withAnimation(.snappy) {
                        showDropdown.toggle()
                    }
                }
                .zIndex(10)

                if state == .bottom && showDropdown {
                    OptionsView()
                }
            }
            .clipped()
            .background(.white)
            .cornerRadius(10)
            .overlay {
                RoundedRectangle(cornerRadius: 10)
                    .stroke(.gray)
            }
            .frame(height: size.height, alignment: state == .top ? .topTrailing : .top)
        }
    }
    .frame(width: maxWidth, height: 50)
    .zIndex(zindex)
    
  }

  func OptionsView() -> some View {
    VStack(spacing: 0) {
      ForEach(options, id: \.self) { option in
        HStack {
          Text(option)
          Spacer()
          Image(systemName: "checkmark")
            .opacity(selection == option ? 1 : 0)
        }
        .foregroundStyle(selection == option ? Color.primary : Color.gray)
        .animation(.none, value: selection)
        .frame(height: 40)
        .contentShape(.rect)
        .padding(.horizontal, 15)
        .onTapGesture {
          withAnimation(.snappy) {
            selection = option
            showDropdown.toggle()
          }
        }
      }
    }
    .transition(.move(edge: state == .top ? .top : .top))
    .zIndex(1)
  }

        /// Only when menu item is highlighted then generate its submenu
    func menu(_ menu: NSMenu, willHighlight item: NSMenuItem?) {

        menu.addItem(item!)
        if let highlightedItem = item, let submenuItems = highlightedItem.submenu?.items, submenuItems.isEmpty {
            if let highlightedFileItem = highlightedItem.representedObject as? NSToolbarItem{
                highlightedItem.submenu = generateSubmenu(highlightedFileItem)
            }
        }
    }

    private func generateSubmenu(_ fileItem: NSToolbarItem) -> EditorPathBarMenu? {

//            let menu = EditorPathBarMenu(
//                fileItems: children,
//                fileManager: nil,
//                tappedOpenFile: mil
//            )
        return NSMenu() as? EditorPathBarMenu
    }
}
// swiftlint: enable all
