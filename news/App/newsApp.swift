//
//  newsApp.swift
//  news
//
//  Created by Всеволод Пантелеев on 22.04.2026.
//

import SwiftUI

@main
struct newsApp: App {
    var body: some Scene {

        let repository = NewsRepositoryImpl(dataSource: NewsDataSourceApi())
        let feedViewModel = FeedViewModel(
            getNewsUseCase: GetNewsUseCaseImpl(repository: repository)
        )
        let filtersViewModel = NewsFiltersViewModel(
            getNewsSourcesUseCase: GetNewsSourcesUseCaseImpl(repository: repository)
        )

        WindowGroup {
            NavigationStack {
                FeedView(
                    viewModel: feedViewModel,
                    filtersViewModel: filtersViewModel
                )
                .navigationDestination(for: News.self) { news in
                    NewsDetailView(news: news)
                }
            }
        }
    }
}
