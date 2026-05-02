//
//  NewsDataSource.swift
//  news
//
//  Created by Всеволод Пантелеев on 22.04.2026.
//

protocol NewsDataSource {
 
    func getNews(search: String?, page: Int?, pageSize: Int) async throws -> [News]
    
}
