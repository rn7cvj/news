//
//  NewsRepository.swift
//  news
//
//  Created by Всеволод Пантелеев on 22.04.2026.
//

import Foundation

protocol NewsRepository {

    func getNews(search: String?, sourceIds: [String]?, language: String?, page: Int?, pageSize: Int) async throws -> [News]
    func getNewsSources(language: String?) async throws -> [NewsCatalogSource]
    
}
