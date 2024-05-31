// swiftlint: disable all
//  Language.swift
//  MathLateX
//
//  Created by christian on 23/05/24.
//

import Foundation

enum Language: String, CaseIterable, Identifiable {
  case Italian
  case English
  case French
  case German
  case Chinese
  var id: Self { self }
}
// swiftlint: enable all
