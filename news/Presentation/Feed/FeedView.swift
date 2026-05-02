//
//  View.swift
//  news
//
//  Created by Всеволод Пантелеев on 22.04.2026.
//

import SwiftUI
import SwiftUIPaginationBuilder

struct FeedView: View {

    @StateObject var viewModel: FeedViewModel

    var body: some View {

        NavigationStack {

            Group {
                switch viewModel.state {
                case .idle, .loading:
                    ProgressView()
                        .frame(maxWidth: .infinity, maxHeight: .infinity)

                case .empty:
                    Text("No news")
                        .frame(maxWidth: .infinity, maxHeight: .infinity)

                case .error(let message):
                    VStack(spacing: 12) {
                        Text("Failed to load news")
                            .font(.headline)
                        Text(message)
                            .font(.footnote)
                            .foregroundStyle(.secondary)
                            .multilineTextAlignment(.center)

                        Button("Retry") {
                            Task {
                                await viewModel.refresh()
                            }
                        }
                    }
                    .padding()
                    .frame(maxWidth: .infinity, maxHeight: .infinity)

                case .loaded(let items, _, _, _):
                    ScrollView {
                        LazyVStack(spacing: 12) {
                            ForEach(Array(items.enumerated()), id: \.element.id) { index, news in
                                NewsView(news: news)
                                    .onAppear {
                                        if index == items.count - 1 {
                                            Task {
                                                await viewModel.loadNextPage()
                                            }
                                        }
                                    }.padding(.horizontal , 16)
                            }

//                            if isLoadingMore {
//                                ProgressView()
//                                    .frame(maxWidth: .infinity)
//                                    .padding(.vertical, 8)
//                            }
                        }
                    }
                }
            }
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
            .navigationTitle(Text("Feed"))
            .onAppear {
                Task {
                    await viewModel.refresh()
                }
            }
//            .refreshable {
//                await viewModel.refresh()
//            }
//            

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
