//
//  GetNewsSourcesUseCase.swift
//  news
//
//  Created by Codex on 02.05.2026.
//

protocol GetNewsSourcesUseCase {
    func exucute(language: String?) async throws -> [NewsCatalogSource]
}

final class GetNewsSourcesUseCaseImpl: GetNewsSourcesUseCase {

    private let repository: NewsRepository

    init(repository: NewsRepository) {
        self.repository = repository
    }

    func exucute(language: String?) async throws -> [NewsCatalogSource] {
        try await repository.getNewsSources(language: language)
    }
}
