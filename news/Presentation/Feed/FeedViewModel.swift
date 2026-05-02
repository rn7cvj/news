//
//  ViewModel.swift
//  news
//
//  Created by Всеволод Пантелеев on 22.04.2026.
//

import Combine
import Foundation


enum FeedState: Equatable {
    case loading
    case loaded
    case fullLoaded
    case empty
    case error(String)
}

@MainActor
final class FeedViewModel: ObservableObject {

    private let getNewsUseCase: GetNewsUseCase

//    @Published var search: String? = nil
    @Published var news : [News] = []
    @Published var currentPage : Int = 0
    @Published var state : FeedState = FeedState.loading
    

    init(getNewsUseCase: GetNewsUseCase) {
        self.getNewsUseCase = getNewsUseCase
    }

    func loadNextPage() {
        
        
        
    }
}
