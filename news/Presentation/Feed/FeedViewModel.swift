//
//  ViewModel.swift
//  news
//
//  Created by Всеволод Пантелеев on 22.04.2026.
//

import Combine
import Foundation

enum FeedState: Equatable {
    case idle
    case loading
    case loaded(items: [News], page: Int, canLoadMore: Bool, isLoadingMore: Bool)
    case empty
    case error(String)
}

@MainActor
final class FeedViewModel: ObservableObject {

    private let getNewsUseCase: GetNewsUseCase
    private let pageSize: Int
    private let initialPage: Int

    private var selectedSourceIds: [String]?
    private var selectedLanguageCode: String
    private var pendingSearchTask: Task<Void, Never>? = nil

    @Published private(set) var searchQuery: String = ""
    @Published private(set) var state: FeedState = .idle

    var news: [News] {
        if case let .loaded(items, _, _, _) = state {
            return items
        }
        return []
    }

    var currentPage: Int {
        if case let .loaded(_, page, _, _) = state {
            return page
        }
        return initialPage
    }

    private var isLoading: Bool {
        switch state {
        case .loading:
            return true
        case let .loaded(_, _, _, isLoadingMore):
            return isLoadingMore
        default:
            return false
        }
    }

    init(getNewsUseCase: GetNewsUseCase, initialLanguageCode: String? = nil) {
        self.getNewsUseCase = getNewsUseCase
        self.pageSize = 16
        self.initialPage = 1
        self.selectedLanguageCode = initialLanguageCode ?? Self.defaultLanguageCode()
        self.selectedSourceIds = nil
    }

    deinit {
        pendingSearchTask?.cancel()
    }

    func applyFilters(languageCode: String, sourceIds: [String]?) async {
        selectedLanguageCode = languageCode
        selectedSourceIds = sourceIds
        await refresh()
    }

    func refresh() async {
        if case .loading = state {
            return
        }
        state = .loading

        do {
            let pageItems = try await fetchPage(page: initialPage)

            if pageItems.isEmpty {
                state = .empty
            } else {
                state = .loaded(
                    items: pageItems,
                    page: initialPage,
                    canLoadMore: pageItems.count == pageSize,
                    isLoadingMore: false
                )
            }
        } catch {
            state = .error(error.localizedDescription)
        }
    }

    func loadNextPage() async {
        guard !isLoading else { return }
        guard case let .loaded(items, page, canLoadMore, _) = state else {
            return
        }
        guard canLoadMore else {
            return
        }

        state = .loaded(
            items: items,
            page: page,
            canLoadMore: canLoadMore,
            isLoadingMore: true
        )
        let nextPage = page + 1

        do {
            let pageItems = try await fetchPage(page: nextPage)
            let allItems = items + pageItems
            state = .loaded(
                items: allItems,
                page: nextPage,
                canLoadMore: pageItems.count == pageSize,
                isLoadingMore: false
            )
        } catch {
            state = .loaded(
                items: items,
                page: page,
                canLoadMore: canLoadMore,
                isLoadingMore: false
            )
        }
    }

    func onSearchQueryChanged(_ query: String) {
        guard query != searchQuery else { return }
        searchQuery = query
        pendingSearchTask?.cancel()

        pendingSearchTask = Task { [weak self] in
            try? await Task.sleep(for: .milliseconds(400))
            guard let self, !Task.isCancelled else { return }

            while case .loading = self.state {
                try? await Task.sleep(for: .milliseconds(150))
                guard !Task.isCancelled else { return }
            }

            await self.refresh()
        }
    }

    private func fetchPage(page: Int) async throws -> [News] {
        try await getNewsUseCase.exucute(
            search: normalizedSearch,
            sourceIds: selectedSourceIds,
            language: selectedLanguageCode,
            page: page,
            pageSize: pageSize
        )
    }

    private var normalizedSearch: String? {
        let query = searchQuery.trimmingCharacters(in: .whitespacesAndNewlines)
        return query.isEmpty ? nil : query
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
