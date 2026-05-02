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

struct News : Codable ,Hashable , Identifiable {
    
    let id: UUID = UUID()
    
    let title: String?
    let description: String?
    
    enum CodingKeys: String, CodingKey {
        case title, description
    }
    

}
