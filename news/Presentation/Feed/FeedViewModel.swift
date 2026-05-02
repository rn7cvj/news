//
//  ViewModel.swift
//  news
//
//  Created by Всеволод Пантелеев on 22.04.2026.
//

import Combine
import Foundation
import SwiftUIPagintaionBuilder

@MainActor
final class FeedViewModel: ObservableObject {

    @Published var search: String?

    let controller: MPBController<News>

    private let getNewsUseCase: GetNewsUseCase

    init(getNewsUseCase: GetNewsUseCase) {
        self.getNewsUseCase = getNewsUseCase
        self.controller = MPBController<News>(

            dataLoader: { pageIndex, pageSize, _ in
                var iterator =
                    getNewsUseCase
                    .exucute(search: nil, page: pageIndex, pageSize: pageSize)
                    .values
                    .makeAsyncIterator()
                return try await iterator.next() ?? []
            },
            initialPageIndex: 1,
            pageSize: 16,
        )
    }

    func refresh(silent : Bool = true) async {
        await controller.refresh(silent: silent)
    }
}
