//
//  ProfileInspectorView.swift
//  MathLateX
//
//  Created by christian on 08/06/24.
//

import SwiftUI

struct ProfileInspectorView: View {
    @EnvironmentObject private var workspace: WorkspaceDocument

    @EnvironmentObject private var editorManager: EditorManager

    @ObservedObject private var model: HistoryInspectorViewModel

    @State var selection: GitCommit?

        /// Initialize with GitClient
        /// - Parameter gitClient: a GitClient
    init() {
        self.model = .init()
    }

    var body: some View {
        Group {
            if model.sourceControlManager != nil {
                VStack {
                    if model.commitHistory.isEmpty {
                        CEContentUnavailableView("No History")
                    } else {
                        List(selection: $selection) {
                            ForEach(model.commitHistory) { commit in
                                HistoryInspectorItemView(commit: commit, selection: $selection)
                                    .tag(commit)
                                    .listRowSeparator(.hidden)
                            }
                        }
                    }
                }
            } else {
                NoSelectionInspectorView()
            }
        }
        .onReceive(editorManager.activeEditor.objectWillChange) { _ in
            Task {
                await model.setFile(url: editorManager.activeEditor.selectedTab?.file.url.path())
            }
        }
        .onChange(of: editorManager.activeEditor) { _ in
            Task {
                await model.setFile(url: editorManager.activeEditor.selectedTab?.file.url.path())
            }
        }
        .onChange(of: editorManager.activeEditor.selectedTab, initial: true) { _,_  in
            Task {
                await model.setFile(url: editorManager.activeEditor.selectedTab?.file.url.path())
            }
        }
        .task {
            await model.setWorkspace(sourceControlManager: workspace.sourceControlManager)
            await model.setFile(url: editorManager.activeEditor.selectedTab?.file.url.path)
        }
    }
}

#Preview {
    ProfileInspectorView()
}
