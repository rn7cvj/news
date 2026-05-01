//
//  View.swift
//  news
//
//  Created by Всеволод Пантелеев on 22.04.2026.
//

import SwiftUI

struct FeedView: View {

    @StateObject var viewModel: FeedViewModel

    var body: some View {

        NavigationStack {

            ScrollView {

                ForEach(viewModel.news, id: \.self) {
                    news in
                    NewsView(news: news)
                        .onAppear {
                            viewModel.loadMoreIfNeeded(currentItem: news)
                        }
                }

                if viewModel.isLoadingPage, !viewModel.news.isEmpty {
                    ProgressView()
                        .padding(.vertical, 12)
                }

            }

            .navigationTitle(Text("Feed"))
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button(
                        action: {},
                        label: {
                            Image(systemName: "line.3.horizontal.decrease")
                        },
                    )
                }
            }
            .overlay(content: {
                if viewModel.news.isEmpty, viewModel.isLoadingPage {
                    ProgressView()
                }
            })
            .refreshable {
                viewModel.refresh()
            }
            .onAppear {
                viewModel.loadInitialIfNeeded()
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
        .padding(8)
    }

}


