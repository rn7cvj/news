//
//  NewsFiltersViewModel.swift
//  news
//
//  Created by Codex on 03.05.2026.
//

import Combine
import Foundation

struct FeedLanguageOption: Hashable, Identifiable {
    let id: String
    let name: String
}

struct FeedSourceOption: Hashable, Identifiable {
    let id: String
    let name: String
}

@MainActor
final class NewsFiltersViewModel: ObservableObject {

    private let getNewsSourcesUseCase: GetNewsSourcesUseCase

    @Published private(set) var availableSources: [NewsCatalogSource] = []
    @Published private(set) var isLoadingSources: Bool = false
    @Published private(set) var sourcesError: String? = nil
    @Published var selectedSourceId: String? = nil
    @Published var selectedLanguageCode: String

    let languageOptions: [FeedLanguageOption] = [
        .init(id: "ar", name: "Arabic"),
        .init(id: "de", name: "German"),
        .init(id: "en", name: "English"),
        .init(id: "es", name: "Spanish"),
        .init(id: "fr", name: "French"),
        .init(id: "he", name: "Hebrew"),
        .init(id: "it", name: "Italian"),
        .init(id: "nl", name: "Dutch"),
        .init(id: "no", name: "Norwegian"),
        .init(id: "pt", name: "Portuguese"),
        .init(id: "ru", name: "Russian"),
        .init(id: "sv", name: "Swedish"),
        .init(id: "ud", name: "Urdu"),
        .init(id: "zh", name: "Chinese")
    ]

    var sourceOptions: [FeedSourceOption] {
        availableSources.compactMap { source in
            guard let id = source.id else { return nil }
            return .init(id: id, name: source.name ?? id)
        }
    }

    init(getNewsSourcesUseCase: GetNewsSourcesUseCase, initialLanguageCode: String? = nil) {
        self.getNewsSourcesUseCase = getNewsSourcesUseCase
        self.selectedLanguageCode = initialLanguageCode ?? Self.defaultLanguageCode()
    }

    func loadSourcesIfNeeded() async {
        await loadSources(force: availableSources.isEmpty)
    }

    func onLanguageChanged(_ languageCode: String) {
        guard selectedLanguageCode != languageCode else { return }
        selectedLanguageCode = languageCode
        selectedSourceId = nil

        Task {
            await loadSources(force: true)
        }
    }

    func sourceName(for id: String?) -> String {
        guard let id else {
            return String(localized: "filters.allSources")
        }

        return availableSources.first(where: { $0.id == id })?.name ?? id
    }

    func resolvedSourceIds() -> [String]? {
        if let selectedSourceId {
            return [selectedSourceId]
        }

        let ids = sourceOptions.map(\.id)
        if ids.isEmpty {
            return nil
        }

        return Array(ids.prefix(20))
    }

    private func loadSources(force: Bool) async {
        if isLoadingSources { return }
        if !force, !availableSources.isEmpty { return }

        isLoadingSources = true
        sourcesError = nil

        defer {
            isLoadingSources = false
        }

        do {
            let sources = try await getNewsSourcesUseCase.exucute(language: selectedLanguageCode)
                .filter { $0.id != nil }
                .sorted { ($0.name ?? "") < ($1.name ?? "") }
            availableSources = sources
            if let selectedSourceId, !sources.contains(where: { $0.id == selectedSourceId }) {
                self.selectedSourceId = nil
            }
        } catch {
            sourcesError = error.localizedDescription
            availableSources = []
            selectedSourceId = nil
        }
    }

    private static func defaultLanguageCode() -> String {
        guard let preferred = Locale.preferredLanguages.first, !preferred.isEmpty else {
            return "en"
        }

        let baseCode = preferred.split(separator: "-").first.map(String.init)?.lowercased() ?? "en"
        let supported = Set(["ar", "de", "en", "es", "fr", "he", "it", "nl", "no", "pt", "ru", "sv", "ud", "zh"])
        return supported.contains(baseCode) ? baseCode : "en"
    }
}
