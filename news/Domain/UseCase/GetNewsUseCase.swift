//
//  GetNewsUseCase.swift
//  news
//
//  Created by Всеволод Пантелеев on 22.04.2026.
//

import Combine

protocol GetNewsUseCase {
    
    func exucute( search : String?, page: Int? , pageSize : Int ) -> AnyPublisher<[News], Error>
    
}


final class GetNewsUseCaseImpl : GetNewsUseCase {
  
    
    private let repository : NewsRepository
    
    
    init(repository: NewsRepository) {
        self.repository = repository
    }
    
    func exucute( search : String?, page: Int?, pageSize: Int) -> AnyPublisher<[News], any Error> {
        repository.getNews(search: search, page: page, pageSize: pageSize)
    }
    
    
}
