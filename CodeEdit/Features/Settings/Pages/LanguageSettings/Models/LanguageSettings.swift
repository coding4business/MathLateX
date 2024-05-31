//
//  LanguageSettings.swift
//  MathLateX
//
//  Created by christian on 30/05/24.
//

import SwiftUI

extension SettingsData {

    struct LanguageSettings: Codable, Hashable, SearchableSettingsPage {

            /// The search keys
        var searchKeys: [String] {
            [
                "Developer",
                "Language Server Protocol",
                "LSP Binaries"
            ]
                .map { NSLocalizedString($0, comment: "") }
        }

            /// A dictionary that stores a file type and a path to an LSP binary
        var languages: [String: String] = [:]

            /// Default initializer
        init() {}

            /// Explicit decoder init for setting default values when key is not present in `JSON`
        init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)

            self.languages = try container.decodeIfPresent(
                [String: String].self,
                forKey: .languages
            ) ?? [:]
        }
    }
}
