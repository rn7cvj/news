//
//  ViewModel.swift
//  news
//
//  Created by Всеволод Пантелеев on 22.04.2026.
//

import Combine
import Foundation

class FeedViewModel: ObservableObject {

    @Published var news: [News] = []
    @Published var error: String? = nil
    @Published private(set) var isLoadingPage = false
    @Published private(set) var canLoadMorePages = true

    private var cancelables = Set<AnyCancellable>()
    private let getNewsUseCase: GetNewsUseCase
    private let firstPage = 1
    private let pageSize = 20
    private var currentPage = 0
    private var hasLoadedInitialPage = false
    private var currentSearch: String?

    init(getNewsUseCase: GetNewsUseCase) {
        self.getNewsUseCase = getNewsUseCase
    }

    func loadInitialIfNeeded(search: String? = nil) {
        guard !hasLoadedInitialPage else {
            return
        }
        hasLoadedInitialPage = true
        refresh(search: search)
    }

    func refresh(search: String? = nil) {
        cancelables.forEach { $0.cancel() }
        cancelables.removeAll()
        currentSearch = search
        error = nil
        news.removeAll()
        currentPage = firstPage - 1
        canLoadMorePages = true
        loadNextPageIfNeeded()
    }

    func loadMoreIfNeeded(currentItem: News) {
        guard currentItem == news.last else {
            return
        }
        loadNextPageIfNeeded()
    }

    private func loadNextPageIfNeeded() {
        guard !isLoadingPage else {
            return
        }

        guard canLoadMorePages else {
            return
        }

        let nextPage = currentPage + 1
        isLoadingPage = true

        getNewsUseCase.exucute(
            search: currentSearch,
            page: nextPage,
            pageSize: pageSize
        )
            .receive(on: DispatchQueue.main)
            .sink(
                receiveCompletion: { [weak self] completion in
                    self?.isLoadingPage = false
                    switch completion {
                    case .failure(let errorValue):
                        self?.error = errorValue.localizedDescription
                        print(errorValue)
                    default:
                        break
                    }
                },
                receiveValue: { [weak self] loadedNews in
                    guard let self else {
                        return
                    }

                    self.currentPage = nextPage
                    self.news.append(contentsOf: loadedNews)
                    self.canLoadMorePages = loadedNews.count >= self.pageSize
                }
            ).store(in: &cancelables)
    }

}
