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

        let viewModel = FeedViewModel(
            getNewsUseCase: GetNewsUseCaseImpl(
                repository: NewsRepositoryImpl(dataSource: NewsDataSourceApi())
            )
        )

        WindowGroup {
            FeedView(
                viewModel: viewModel
            )
        }
    }
}
