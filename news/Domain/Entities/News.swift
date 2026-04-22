//
//  News.swift
//  news
//
//  Created by Всеволод Пантелеев on 22.04.2026.
//

import Foundation


struct Articales : Codable ,Hashable  {
    
    let totalResults : Int?
    let articles : [News]
}

struct News : Codable ,Hashable  {
    
    let title: String?
    let description: String?
    
}
