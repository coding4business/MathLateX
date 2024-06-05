//
//  UserProfileMenu.swift
//  MathLateX
//
//  Created by christian on 02/06/24.
//

import SwiftUI

struct Shadow: View {
  let steps = [0, 5, 10]

  var body: some View {
    VStack(spacing: 50) {
      ForEach(steps, id: \.self) { offset in
        HStack(spacing: 50) {
          ForEach(steps, id: \.self) { radius in
            Color.blue
              .shadow(
                color: .primary,
                radius: CGFloat(radius),
                x: CGFloat(offset), y: CGFloat(offset)
              )
              .overlay {
                VStack {
                  Text("\(radius)")
                  Text("(\(offset), \(offset))")
                }
              }
          }
        }
      }
    }
  }
}

struct RedBorderedButtonStyle: PrimitiveButtonStyle {
  func makeBody(configuration: Configuration) -> some View {
    Button(configuration)
      .frame(width: 38, height: 38, alignment: .topTrailing)
      .border(Color.red, width: 2)
      .buttonBorderShape(.circle)
      .buttonStyle(.plain)
      .labelStyle(.iconOnly)
  }
}

struct UserProfileMenu: View {
  var user: User

  @State var showHint: Bool = false

  @Namespace var animator
  var body: some View {
    HStack(alignment: .center) {
      Button {
        showHint.toggle()
      } label: {
        AsyncImage(
          url: URL(string: user.avatarURLString)!,
          placeholder: {
            Image(systemName: "person.circle.fill")
              .resizable()
              .clipShape(Circle())
              .frame(width: 40, height: 40)
          },
          image: { Image(nsImage: $0).resizable() }
        )
        .frame(width: 40, height: 40)
        .aspectRatio(1.0, contentMode: .fill)
        .background(Color.init(hex: "#272c33"))
        .clipShape(.circle)
        .overlay(
          Circle()
            .stroke(Color.gray.quinary, lineWidth: 1.5)
        )
        .preferredColorScheme(.dark)
      }
      .buttonStyle(.plain)
      .popover(isPresented: $showHint) {
        VStack {
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
}
