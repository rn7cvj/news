//
//  NewsRepository.swift
//  news
//
//  Created by Всеволод Пантелеев on 22.04.2026.
//

import Foundation
import Combine

protocol NewsRepository {

    func getNews( search : String?, page: Int? , pageSize : Int ) -> AnyPublisher<[News] , Error>
    
}
