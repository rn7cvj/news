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

            ScrollView {
                LazyVStack(spacing: 12) {
                    ForEach(viewModel.news) { news in
                        NewsView(news: news)
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
                  await  viewModel.refresh()
                }
                
            }
            .refreshable {
                
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
