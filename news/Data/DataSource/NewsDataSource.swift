//
//  NewsDataSource.swift
//  news
//
//  Created by Всеволод Пантелеев on 22.04.2026.
//

protocol NewsDataSource {
 
    func getNews(search: String?, sourceIds: [String]?, language: String?, page: Int?, pageSize: Int) async throws -> [News]
    func getNewsSources(language: String?) async throws -> [NewsCatalogSource]
    
}
