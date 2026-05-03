//
//  NewsRepository.swift
//  news
//
//  Created by Всеволод Пантелеев on 22.04.2026.
//

import Foundation

final class  NewsRepositoryImpl : NewsRepository {

    private let dataSource : NewsDataSource
    
    init(dataSource: NewsDataSource) {
        self.dataSource = dataSource
    }
    
    func getNews(search: String?, sourceIds: [String]?, language: String?, page: Int?, pageSize: Int) async throws -> [News] {
        try await dataSource.getNews(search: search, sourceIds: sourceIds, language: language, page: page, pageSize: pageSize)
    }

    func getNewsSources(language: String?) async throws -> [NewsCatalogSource] {
        try await dataSource.getNewsSources(language: language)
    }
    
}
