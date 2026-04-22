//
//  NewsRepository.swift
//  news
//
//  Created by Всеволод Пантелеев on 22.04.2026.
//

import Foundation
import Combine

final class  NewsRepositoryImpl : NewsRepository {

    private let dataSource : NewsDataSource
    
    init(dataSource: NewsDataSource) {
        self.dataSource = dataSource
    }
    
    func getNews( search : String?, page: Int? , pageSize : Int ) -> AnyPublisher<[News] , Error> {
        dataSource.getNews(search: search, page: page, pageSize: pageSize)
    }
    
}
