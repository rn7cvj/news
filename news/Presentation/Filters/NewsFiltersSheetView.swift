//
//  NewsFiltersSheetView.swift
//  news
//
//  Created by Codex on 02.05.2026.
//

import SwiftUI

struct NewsFiltersSheetView: View {

    @ObservedObject var viewModel: NewsFiltersViewModel
    let onApply: () async -> Void

    @Environment(\.dismiss) private var dismiss

    private var selectedLanguageName: String {
        viewModel.languageOptions.first(where: {
            $0.id == viewModel.selectedLanguageCode
        })?.name ?? viewModel.selectedLanguageCode.uppercased()
    }

    private var selectedSourceName: String {
        viewModel.sourceName(for: viewModel.selectedSourceId)
    }

    var body: some View {
        VStack(spacing: 16) {
            Text("filters.title").font(.title)

            // Language
            HStack {
                Text("filters.language")
                    .font(.headline)
                Spacer()
                Picker(
                    "filters.language",
                    selection: Binding(
                        get: { viewModel.selectedLanguageCode },
                        set: { viewModel.onLanguageChanged($0) }
                    )
                ) {
                    ForEach(viewModel.languageOptions) { language in
                        Text(language.name)
                            .tag(language.id)
                    }
                }
                .pickerStyle(.menu)
            }

            // Spource
            HStack {
                Text("filters.source")
                    .font(.headline)
                Spacer()
                Picker("filters.source", selection: $viewModel.selectedSourceId)
                {
                    Text("filters.allSources")
                        .tag(String?.none)

                    ForEach(viewModel.sourceOptions) { source in
                        Text(source.name)
                            .tag(Optional(source.id))
                    }
                }
                .pickerStyle(.menu)
                .disabled(
                    viewModel.isLoadingSources
                        || viewModel.availableSources.isEmpty
                )
            }

            Button(
                action: {
                    dismiss()
                    Task {
                        await onApply()
                    }
                },
                label: {
                    Text("filters.apply")
                },
            )
            .buttonStyle(GlassButtonStyle())
            .tint(.blue)
            .controlSize(.large)

        }
        .padding()
    }
}
