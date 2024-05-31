//
//  LanguageSettingsView.swift
//  MathLateX
//
//  Created by christian on 23/05/24.
//

import SwiftUI

struct LanguageSettingsView: View {
    @AppSettings(\.languageSettings.languages)
    var languages

    var body: some View {
        SettingsForm {
            Section {
                KeyValueTable(
                    items: $languages,
                    keyColumnName: "Language",
                    valueColumnName: "Language Server Path",
                    newItemInstruction: "Add a language server"
                ) {
                    Text("Add a language server")
                    Text(
                        "Specify the absolute path to your LSP binary and its associated language."
                    )
                }
            } header: {
                Text("LSP Binaries")
                Text("Specify the language and the absolute path to the language server binary.")
            }
        }
    }
}
