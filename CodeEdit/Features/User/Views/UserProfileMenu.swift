//
//  UserProfileMenu.swift
//  MathLateX
//
//  Created by christian on 02/06/24.
//

import SwiftUI

struct UserProfileMenu: View {
  var user: User

  @State var showHint: Bool = false

  @Namespace var animator
  var body: some View {
    Button {
      showHint.toggle()
    } label: {
      AsyncImage(
        url: URL(string: user.avatarURLString)!,
        placeholder: { Text("Loading ...") },
        image: { Image(nsImage: $0).resizable() }
      )
      .frame(width: 38, height: 38)
      .aspectRatio(contentMode: .fill)
      .background(Color.init(hex: "#2d2f31"))
      .clipShape(Circle())
      .overlay(
        Circle()
          .frame(width: 1, height: 1, alignment: .center)
          .border(.gray, width: 1.5)
          .background(.gray)
      )
    }
    .buttonStyle(.plain)
    .popover(isPresented: $showHint) {
      VStack(alignment: .trailing) {
        HStack(
          content: {
            UserRowView(user: user)
          })
          .padding(6)
        Divider()

        HStack(
          content: {
            UserRowView(user: user)
          })
          .padding(6)
        Divider()
      }
      .frame(width: 300)
      .padding(6)

    }
  }
}
