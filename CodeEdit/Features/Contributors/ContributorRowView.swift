//
//  ContributorRowView.swift
//  CodeEdit
//
//  Created by Lukas Pistrol on 19.01.23.
//

import SwiftUI

struct ContributorRowView: View {

  let contributor: Contributor

  var body: some View {
    HStack {
      userImage
      VStack(alignment: .leading) {
        HStack(spacing: 4) {
          Text(contributor.name)
            .font(.headline)
        }
          Spacer()
        HStack(spacing: 3) {
          ForEach(contributor.contributions, id: \.self) { item in
            tag(item)
          }
          Spacer()
          HStack(alignment: .bottom) {
              if let gitHubtURL = contributor.profileURL {
                  ActionButton(url: gitHubtURL, image: .github)
              }
              if let gitHubggURL = contributor.profileURL {
                  ActionButton(url: gitHubggURL, image: .init(systemName: "globe"))
              }
            if let gitHubURL = contributor.profileURL {
              ActionButton(url: gitHubURL, image: .github)
            }
          }
        }
      }
    }
    .padding(.vertical, 4)
    .padding(.horizontal, 4)
  }

  private var userImage: some View {
      SwiftUI.AsyncImage(url: contributor.avatarURL) { image in
      image
        .resizable()
        .frame(width: 48, height: 48)
        .clipShape(Ellipse())
        .help(contributor.name)
        .padding(.trailing, 6)
    } placeholder: {
      Image(systemName: "person.circle.fill")
        .resizable()
        .padding(.trailing, 6)
        .clipShape(Ellipse())
        .frame(width: 48, height: 48)
        .help(contributor.name)
    }
  }

  private func tag(_ item: Contributor.Contribution) -> some View {
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

   struct ActionButton: View {
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
