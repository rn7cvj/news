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

        Group {
            switch viewModel.state {
            case .idle, .loading:
                ProgressView()
                    .frame(maxWidth: .infinity, maxHeight: .infinity)

            case .empty:
                Text("feed.empty")
                    .frame(maxWidth: .infinity, maxHeight: .infinity)

            case .error(let message):
                VStack(spacing: 12) {
                    Text("feed.error")
                        .font(.headline)
                    Text(message)
                        .font(.footnote)
                        .foregroundStyle(.secondary)
                        .multilineTextAlignment(.center)

                    Button("feed.retry") {
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
                        ForEach(Array(items.enumerated()), id: \.element.id)
                        { index, news in
                            NavigationLink(value: news) {
                                FeedNewsView(news: news)
                            }
                            .buttonStyle(.plain)
                            .padding(.horizontal, 16)
                                .onAppear {
                                    if index == items.count - 1 {
                                        Task {
                                            await viewModel.loadNextPage()
                                        }
                                    }
                                }
                        }

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
        .navigationTitle("feed.title")
        .onAppear {
            Task {
                await viewModel.refresh()
            }
        }
        .refreshable {
            await viewModel.refresh()
        }
    }

}
