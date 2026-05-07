//
//  MovieDetailView.swift
//  UTS Cinemas
//
//  Created by Ameer Ali on 4/5/2026.
//

import SwiftUI

struct MovieDetailView: View {
    let movie: TMDBMovie
    @State private var showShowtimes = false

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 0) {
                // Poster
                AsyncImage(url: movie.posterURL) { image in
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                } placeholder: {
                    Rectangle()
                        .fill(.gray.opacity(0.2))
                        .overlay(ProgressView())
                }
                .frame(maxWidth: .infinity)
                .frame(height: 400)
                .clipped()

                VStack(alignment: .leading, spacing: 16) {
                    // Title
                    Text(movie.title)
                        .font(.title)
                        .fontWeight(.bold)

                    // Rating and runtime row
                    HStack(spacing: 16) {
                        HStack(spacing: 4) {
                            Image(systemName: "star.fill")
                                .foregroundStyle(.yellow)
                            Text(movie.formattedRating)
                                .fontWeight(.semibold)
                        }

                        if let runtime = movie.runtime, runtime > 0 {
                            HStack(spacing: 4) {
                                Image(systemName: "clock")
                                    .foregroundStyle(.secondary)
                                Text("\(runtime / 60)h \(runtime % 60)m")
                                    .foregroundStyle(.secondary)
                            }
                        }

                        Text(movie.releaseDate.prefix(4))
                            .foregroundStyle(.secondary)
                    }
                    .font(.subheadline)

                    Divider()

                    // Synopsis
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Synopsis")
                            .font(.headline)
                        Text(movie.overview)
                            .font(.body)
                            .foregroundStyle(.secondary)
                            .lineSpacing(4)
                    }

                    // Book Now button
                    Button {
                        showShowtimes = true
                    } label: {
                        Text("Book Now")
                            .font(.headline)
                            .foregroundStyle(.white)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 16)
                            .background(
                                RoundedRectangle(cornerRadius: 14, style: .continuous)
                                    .fill(.red)
                            )
                    }
                    .padding(.top, 8)
                }
                .padding(20)
            }
        }
        .ignoresSafeArea(edges: .top)
        .navigationBarTitleDisplayMode(.inline)
        .sheet(isPresented: $showShowtimes) {
            ShowtimesView(movie: movie)
        }
    }
}
