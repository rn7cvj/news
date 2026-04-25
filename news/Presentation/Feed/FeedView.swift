//
//  View.swift
//  news
//
//  Created by Всеволод Пантелеев on 22.04.2026.
//

import SwiftUI

struct FeedView: View {

    @StateObject var viewModel: FeedViewModel

    @State private var searchText = ""

    var body: some View {

        NavigationStack {

            ScrollView {

                ForEach(viewModel.news, id: \.self) {
                    news in NewsView(news: news)
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
                if viewModel.news.isEmpty {
                    ProgressView()
                }
            })
            .refreshable {
                viewModel.refresh(search: searchText)
            }
            .onAppear {
                viewModel.getNews()
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

struct ImageCarousel: View {
    let urls = [
        URL(string: "https://picsum.photos/id/239/200/300")!,
        URL(string: "https://picsum.photos/id/240/200/300")!,
        URL(string: "https://picsum.photos/id/241/200/300")!,
    ]

    var body: some View {
        TabView {
            ForEach(urls, id: \.self) { url in
                AsyncImage(url: url) { image in
                    image
                        .resizable()
                        .scaledToFill()
                } placeholder: {
                    ProgressView()
                }
                .frame(height: 200)
                .clipShape(RoundedRectangle(cornerRadius: 16))
                .padding(.horizontal, 16)
            }
        }
        .frame(height: 220)
        .tabViewStyle(.page(indexDisplayMode: .automatic))
    }
}
