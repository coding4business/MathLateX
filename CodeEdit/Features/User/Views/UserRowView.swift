//
//  UserRowView.swift
//  MathLateX
//
//  Created by christian on 03/06/24.
//

import SwiftUI

struct UserRowView: View {

  let user: User

  var body: some View {
    ZStack {
        HStack {
            userImage
            VStack(alignment: .leading) {
                HStack(spacing: 8) {
                    Text(user.name)
                        .font(.headline)
                }
                Spacer()
                HStack(spacing: 8) {
                    ForEach(user.users, id: \.self) { item in
                        tag(item)
                    }
                    Spacer()
                    HStack(alignment: .bottom) {
                        ActionButton(url: user.profileURL!, image: .init(systemName: "globe"))
                        ActionButton(url: user.profileURL!, image: .init(systemName: "person"))
                        ActionButton(url: user.profileURL!, image: .init(systemName: "plus"))
                    }
                }
            }
        }
    }
    .padding(.vertical, 8)
  }

  private var userImage: some View {
      SwiftUI.AsyncImage(url: URL(string: user.avatarURLString)) { image in
          image
              .resizable()
              .frame(width: 48, height: 48)
              .clipShape(Ellipse())
              .help(user.name)
              .padding(.trailing, 6)
      } placeholder: {
          Image(systemName: "person.circle.fill")
              .resizable()
              .padding(.trailing, 6)
              .clipShape(Ellipse())
              .frame(width: 48, height: 48)
              .help(user.name)
      }
  }

  private func tag(_ item: User.UserCategory) -> some View {
    Text(item.rawValue.capitalized)
      .font(.caption)
      .padding(.horizontal, 6)
      .padding(.vertical, 6)
      .foregroundColor(item.color)
      .background {
        Capsule(style: .continuous)
          .strokeBorder(lineWidth: 1)
          .foregroundStyle(item.color)
          .opacity(0.8)
      }
  }

  private struct ActionButton: View {
    @Environment(\.openURL)
    private var openURL
    @State private var hovering = false

    let url: URL
    let image: Image

    var body: some View {
      Button {
        openURL(url)
      } label: {
        image
          .imageScale(.medium)
          .foregroundColor(hovering ? .primary : .secondary)
      }
      .buttonStyle(.plain)
      .onHover { hover in
        hovering = hover
      }
    }
  }
}
