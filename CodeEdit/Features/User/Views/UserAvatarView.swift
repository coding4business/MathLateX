//
//  UserAvatarView.swift
//  MathLateX
//
//  Created by christian on 30/05/24.
//

import SwiftUI

typealias User = Contributor

struct UserAvatarView: View {
  let user: Contributor

  // return the toolbar item
  var body: some View {

    // set the view property of the toolbar item
    HStack {
      userImage
      VStack(alignment: .leading, spacing: 2) {
        HStack {
          Text(user.name)
            .font(.headline)
        }
        HStack(spacing: 3) {
          ForEach(user.contributions, id: \.self) { item in
            tag(item)
          }
        }
      }
      Spacer()
      HStack(alignment: .top) {
        if let profileURL = user.profileURL, profileURL != user.gitHubURL {
          ActionButton(url: profileURL, image: .init(systemName: "globe"))
        }
        if let gitHubURL = user.gitHubURL {
          ActionButton(url: gitHubURL, image: .github)
        }
      }
    }
    .padding(.vertical, 8)
  }

  public var userImage: some View {
    AsyncImage(url: user.avatarURL) { image in
      image
        .resizable()
        .frame(width: 32, height: 32)
        .clipShape(Circle())
        .help(user.name)
    } placeholder: {
      Image(systemName: "person.circle.fill")
        .resizable()
        .frame(width: 32, height: 32)
        .help(user.name)
    }
  }

  public func tag(_ item: Contributor.Contribution) -> some View {
    Text(item.rawValue.capitalized)
      .font(.caption)
      .padding(.horizontal, 6)
      .padding(.vertical, 1)
      .foregroundColor(item.color)
      .background {
        Capsule(style: .continuous)
          .strokeBorder(lineWidth: 1)
          .foregroundStyle(item.color)
          .opacity(0.8)
      }
  }
  public struct ActionButton: View {
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
