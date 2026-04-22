//
//  NewsDataSource.swift
//  news
//
//  Created by Всеволод Пантелеев on 22.04.2026.
//

import Combine

protocol NewsDataSource {
 
    func getNews(search : String?, page: Int? , pageSize : Int ) -> AnyPublisher<[News] , Error>
    
}
