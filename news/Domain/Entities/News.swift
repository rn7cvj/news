//
//  News.swift
//  news
//
//  Created by Всеволод Пантелеев on 22.04.2026.
//

import Foundation
import SwiftUIPaginationBuilder

struct Articales : Codable ,Hashable   {
    
    let totalResults : Int?
    let articles : [News]
}

struct NewsSource: Codable, Hashable {
    let id: String?
    let name: String?
}

struct News : Codable ,Hashable , Identifiable {
    
    let id: UUID = UUID()
    let source: NewsSource?
    let author: String?
    let title: String?
    let description: String?
    let url: String?
    let urlToImage: String?
    let publishedAt: String?
    let content: String?
    
    enum CodingKeys: String, CodingKey {
        case source, author, title, description, url, urlToImage, publishedAt, content
    }
    
}
