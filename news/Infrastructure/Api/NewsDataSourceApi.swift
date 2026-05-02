//
//  News.swift
//  news
//
//  Created by Всеволод Пантелеев on 22.04.2026.
//

import Foundation

final class NewsDataSourceApi: NewsDataSource {

    private var apiKey: String?
    private var languageCode: String {
        guard let preferred = Locale.preferredLanguages.first, !preferred.isEmpty else {
            return "en"
        }

        let baseCode = preferred.split(separator: "-").first.map(String.init) ?? preferred
        return String(baseCode.prefix(2)).lowercased()
    }

    init() {
        self.apiKey = Bundle.main.object(forInfoDictionaryKey: "NEWS_API_KEY") as? String
    }

    private func makeNewsURL(search: String?, page: Int?, pageSize: Int) -> URL?
    {
        var components = URLComponents()
        components.scheme = "https"
        components.host = "newsapi.org"
        components.path = "/v2/everything"

        @ArrayBuilder<URLQueryItem>
        var queryItems: [URLQueryItem] {
            if let apiKey {
                URLQueryItem(name: "apiKey", value: apiKey)

            }
            URLQueryItem(name: "sources", value: "google-news-ru")
            URLQueryItem(name: "language", value: languageCode)
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

    func getNews(search: String?, page: Int?, pageSize: Int) async throws -> [News] {

        guard
            let url = makeNewsURL(
                search: search,
                page: page,
                pageSize: pageSize
            )
        else {
            throw URLError(.badURL)
        }

        let (data, _) = try await URLSession.shared.data(from: url)

        if let json = String(data: data, encoding: .utf8) {
            print(String(localized: "debug.apiResponse"), json)
        }

        return try JSONDecoder().decode(Articales.self, from: data).articles
    }

}
