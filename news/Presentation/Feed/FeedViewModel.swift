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

    @Published var search: String? = nil
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

    init(getNewsUseCase: GetNewsUseCase) {
        self.getNewsUseCase = getNewsUseCase
        self.pageSize = 16
        self.initialPage = 1
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

    private func fetchPage(page: Int) async throws -> [News] {
        try await getNewsUseCase.exucute(search: search, page: page, pageSize: pageSize)
    }
}
