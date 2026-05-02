//
//  GetNewsUseCase.swift
//  news
//
//  Created by Всеволод Пантелеев on 22.04.2026.
//

protocol GetNewsUseCase {
    
    func exucute(search: String?, page: Int?, pageSize: Int) async throws -> [News]
    
}


final class GetNewsUseCaseImpl : GetNewsUseCase {
  
    
    private let repository : NewsRepository
    
    
    init(repository: NewsRepository) {
        self.repository = repository
    }
    
    func exucute(search: String?, page: Int?, pageSize: Int) async throws -> [News] {
        try await repository.getNews(search: search, page: page, pageSize: pageSize)
    }
    
    
}
