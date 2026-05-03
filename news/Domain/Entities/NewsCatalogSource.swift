//
//  NewsCatalogSource.swift
//  news
//
//  Created by Codex on 02.05.2026.
//

import Foundation

struct NewsSourcesResponse: Codable, Hashable {
    let sources: [NewsCatalogSource]
}

struct NewsCatalogSource: Codable, Hashable {
    let id: String?
    let name: String?
    let description: String?
    let url: String?
    let category: String?
    let language: String?
    let country: String?
}
