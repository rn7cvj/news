//
//  ViewModel.swift
//  news
//
//  Created by Всеволод Пантелеев on 22.04.2026.
//

import Combine
import Foundation

class FeedViewModel: ObservableObject {

    @Published var news: [News] = []
    @Published var error: String? = nil

    private var cancelables = Set<AnyCancellable>()
    private let getNewsUseCase: GetNewsUseCase

    init(getNewsUseCase: GetNewsUseCase) {
        self.getNewsUseCase = getNewsUseCase
    }

    func getNews(
        search: String? = nil,
        page: Int? = nil,
        pageSize: Int = 64,
    ) {
        getNewsUseCase.exucute(search: search, page: page, pageSize: pageSize)
            .receive(on: DispatchQueue.main).sink(
                receiveCompletion: { [weak self] completion in
                    switch completion {
                    case .failure(let errorValue):
                        self?.error = errorValue.localizedDescription
                        print(errorValue)
                    default:
                        break
                    }
                },
                receiveValue: { [weak self] news in
                    self?.news = news
                }
            ).store(in: &cancelables)
    }

}
