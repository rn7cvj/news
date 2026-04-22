//
//  News.swift
//  news
//
//  Created by Всеволод Пантелеев on 22.04.2026.
//

import Foundation
import Combine

final class NewsDataSourceApi: NewsDataSource {

    private var apiKey: String = "34d96505c96143bd9a6d3e2ee9b91343"

    private func makeNewsURL(search: String?, page: Int?, pageSize: Int) -> URL?
    {
        var components = URLComponents()
        components.scheme = "https"
        components.host = "newsapi.org"
        components.path = "/v2/everything"

        @ArrayBuilder<URLQueryItem>
        var queryItems: [URLQueryItem] {
            URLQueryItem(name: "apiKey", value: apiKey)
            if let search, !search.isEmpty {
                URLQueryItem(name: "q", value: search)
            }
            if let page, page >= 0 {

                URLQueryItem(name: "page", value: "\(page)")
            }
            if let page, page >= 0, pageSize > 0 {
                URLQueryItem(name: "pageSize", value: "\(pageSize)")
            }

        }

        components.queryItems = queryItems

        return components.url
    }

    func getNews(search: String?, page: Int?, pageSize: Int) -> AnyPublisher<
        [News], any Error
    > {

        guard
            let url = makeNewsURL(
                search: search,
                page: page,
                pageSize: pageSize
            )
        else {
            return Fail(error: URLError(.badURL)).eraseToAnyPublisher()
        }

        let dataPuplisher = URLSession.shared.dataTaskPublisher(for: url).map(
            \.data
        ).decode(type: Articales.self, decoder: JSONDecoder()).map{$0.articles}.eraseToAnyPublisher()
        
        return dataPuplisher

    }

}
