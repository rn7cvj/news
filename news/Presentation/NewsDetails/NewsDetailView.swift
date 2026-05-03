//
//  NewsDetailView.swift
//  news
//
//  Created by Codex on 02.05.2026.
//

import SwiftUI

struct NewsDetailView: View {

    let news: News

    private var imageURL: URL? {
        guard let urlString = news.urlToImage else { return nil }
        return URL(string: urlString)
    }

    private var articleURL: URL? {
        guard let urlString = news.url else { return nil }
        return URL(string: urlString)
    }

    private var publishedAtText: String? {
        guard let rawDate = news.publishedAt else { return nil }
        let parser = ISO8601DateFormatter()
        guard let date = parser.date(from: rawDate) else {
            return rawDate
        }

        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter.string(from: date)
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                if let imageURL {
                    ZStack {
                        Color.gray.opacity(0.12)

                        AsyncImage(url: imageURL, transaction: .init(animation: .easeInOut)) { phase in
                            switch phase {
                            case .success(let image):
                                image
                                    .resizable()
                                    .scaledToFill()
                                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                            case .failure:
                                Image(systemName: "photo")
                                    .font(.title2)
                                    .foregroundStyle(.secondary)
                                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                            case .empty:
                                ProgressView()
                                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                            @unknown default:
                                EmptyView()
                            }
                        }
                    }
                    .frame(maxWidth: .infinity)
                    .frame(height: 220)
                    .clipped()
                    .clipShape(RoundedRectangle(cornerRadius: 16))
                }

                if let sourceName = news.source?.name {
                    Text(sourceName)
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }

                if let title = news.title {
                    Text(title)
                        .font(.title2.bold())
                }

                if let publishedAtText {
                    Text(publishedAtText)
                        .font(.footnote)
                        .foregroundStyle(.secondary)
                }

                if let author = news.author {
                    Text(String(format: String(localized: "news.by"), author))
                        .font(.footnote)
                        .foregroundStyle(.secondary)
                }

                if let description = news.description {
                    Text(description)
                        .font(.body)
                }

                if let content = news.content {
                    Text(content)
                        .font(.body)
                        .foregroundStyle(.secondary)
                }

                if let articleURL {
                    Link("news.openOriginal", destination: articleURL)
                        .font(.headline)
                        .padding(.top, 4)
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
        }
        .navigationTitle("news.title")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            if let articleURL {
                ToolbarItem(placement: .topBarTrailing) {
                    ShareLink(item: articleURL) {
                        Image(systemName: "square.and.arrow.up")
                    }
                    .accessibilityLabel("news.share")
                }
            }
        }
    }
}
