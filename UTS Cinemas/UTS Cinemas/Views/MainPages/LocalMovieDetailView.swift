//
//  LocalMovieDetailView.swift
//  UTS Cinemas
//
//  Created by Ameer Ali on 10/5/2026.
//

import SwiftUI

struct LocalMovieDetailView: View {
    let movie: Movie

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                Image(movie.posterImageName)
                    .resizable()
                    .scaledToFit()
                    .cornerRadius(20)
                    .shadow(radius: 10)

                VStack(alignment: .leading, spacing: 12) {
                    Text(movie.title)
                        .font(.largeTitle)
                        .fontWeight(.bold)
                    Text(movie.genre)
                        .foregroundStyle(.secondary)
                    Text("Duration: \(movie.durationMinutes) min")
                    Text("Rating: \(movie.rating.rawValue.uppercased())")
                    Text("Cinema: \(movie.location)")
                    Text(movie.description)
                        .padding(.top, 8)
                }

                if let trailerURL = URL(string: movie.trailerURL),
                   !movie.trailerURL.isEmpty {
                    Link(destination: trailerURL) {
                        HStack {
                            Image(systemName: "play.fill")
                            Text("Watch Trailer")
                        }
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.red)
                        .foregroundColor(.white)
                        .clipShape(RoundedRectangle(cornerRadius: 16))
                    }
                }
            }
            .padding()
        }
        .navigationTitle(movie.title)
        .navigationBarTitleDisplayMode(.inline)
    }
}
