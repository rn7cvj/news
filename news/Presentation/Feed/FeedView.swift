//
//  View.swift
//  news
//
//  Created by Всеволод Пантелеев on 22.04.2026.
//

import SwiftUI
import SwiftUIPagintaionBuilder

struct FeedView: View {

    @StateObject var viewModel: FeedViewModel

    var body: some View {

        NavigationStack {
            MPBBuilder(
                controller: viewModel.controller,
                spacing: 16,
                padding: EdgeInsets(),
                itemBuilder: { _, news, _, _, _ in
                    NewsView(news: news)
                },
                firstLoadingBuilder: { _ in
                    ProgressView()
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                },
                noItemBuilder: { _ in
                    Text("No news")
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                }
            )
            .navigationTitle(Text("Feed"))
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button(
                        action: {},
                        label: {
                            Image(systemName: "line.3.horizontal.decrease")
                        }
                    )
                }
            }
            .refreshable {
                await viewModel.refresh()
            }
        }

    }

}

struct NewsView: View {

    let news: News

    var body: some View {

        VStack(alignment: .leading, spacing: 8) {

            if let title = news.title {
                Text(title).font(.title2)
            }

            if let desciption = news.description {
                Text(
                    desciption
                ).font(.default)

            }

        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
        .background(.regularMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }

}
