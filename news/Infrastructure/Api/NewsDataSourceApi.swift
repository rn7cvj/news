//
//  News.swift
//  news
//
//  Created by Всеволод Пантелеев on 22.04.2026.
//

import Foundation

final class NewsDataSourceApi: NewsDataSource {

    private var apiKey: String?
    private var preferredLanguageCode: String {
        guard let preferred = Locale.preferredLanguages.first, !preferred.isEmpty else {
            return "en"
        }

        let baseCode = preferred.split(separator: "-").first.map(String.init) ?? preferred
        return String(baseCode.prefix(2)).lowercased()
    }

    init() {
        self.apiKey = Bundle.main.object(forInfoDictionaryKey: "NEWS_API_KEY") as? String
    }

    private func resolveLanguageCode(_ language: String?) -> String {
        guard let language, !language.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            return preferredLanguageCode
        }

        return language.lowercased()
    }

    private func makeNewsURL(search: String?, sourceIds: [String]?, language: String?, page: Int?, pageSize: Int) -> URL?
    {
        var components = URLComponents()
        components.scheme = "https"
        components.host = "newsapi.org"
        components.path = "/v2/everything"
        let languageCode = resolveLanguageCode(language)

        let resolvedSourceIds = sourceIds?
            .prefix(20)
            .map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }
            .filter { !$0.isEmpty }

        @ArrayBuilder<URLQueryItem>
        var queryItems: [URLQueryItem] {
            if let apiKey {
                URLQueryItem(name: "apiKey", value: apiKey)

            }
            if let resolvedSourceIds, !resolvedSourceIds.isEmpty {
                URLQueryItem(name: "sources", value: resolvedSourceIds.joined(separator: ","))
            } else {
                URLQueryItem(name: "sources", value: "google-news-ru")
            }
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

    private func makeNewsSourcesURL(language: String?) -> URL? {
        var components = URLComponents()
        components.scheme = "https"
        components.host = "newsapi.org"
        components.path = "/v2/top-headlines/sources"
        let languageCode = resolveLanguageCode(language)

        @ArrayBuilder<URLQueryItem>
        var queryItems: [URLQueryItem] {
            if let apiKey {
                URLQueryItem(name: "apiKey", value: apiKey)
            }
            URLQueryItem(name: "language", value: languageCode)
        }

        components.queryItems = queryItems
        return components.url
    }

    func getNews(search: String?, sourceIds: [String]?, language: String?, page: Int?, pageSize: Int) async throws -> [News] {

        guard
            let url = makeNewsURL(
                search: search,
                sourceIds: sourceIds,
                language: language,
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

    func getNewsSources(language: String?) async throws -> [NewsCatalogSource] {
        guard let url = makeNewsSourcesURL(language: language) else {
            throw URLError(.badURL)
        }

        let (data, _) = try await URLSession.shared.data(from: url)
        return try JSONDecoder().decode(NewsSourcesResponse.self, from: data).sources
    }

}
