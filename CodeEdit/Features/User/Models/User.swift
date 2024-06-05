//
//  User.swift
//  MathLateX
//
//  Created by christian on 03/06/24.
//

import Foundation
import SwiftUI

/// user entity
open class UsersRoot {
  var users: [User] = []
}

open class User: Identifiable {
  public var id: String { login }
  var login: String
  var name: String
  var avatarURLString: String
  var profile: String
  var users: [UserCategory]

  init(login: String, name: String, avatarURLString: String, profile: String, users: [UserCategory]) {
    self.login = login
    self.name = name
    self.avatarURLString = avatarURLString
    self.profile = profile
    self.users = users
  }

  var avatarURL: URL? {
    URL(string: avatarURLString)
  }

  var gitHubURL: URL? {
    URL(string: "https://github.com/\(login)")
  }

  var profileURL: URL? {
    URL(string: profile)
  }

  enum CodingKeys: String, CodingKey {
    case login, name, profile, contributions
    case avatarURLString = "avatar_url"
  }

  enum UserCategory: String, Codable {
    case design, code, infra, test, bug, maintenance, plugin

    var color: Color {
      switch self {
      case .design: return .blue
      case .code: return .indigo
      case .infra: return .pink
      case .test: return .purple
      case .bug: return .red
      case .maintenance: return .brown
      case .plugin: return .gray
      }
    }
  }
}
