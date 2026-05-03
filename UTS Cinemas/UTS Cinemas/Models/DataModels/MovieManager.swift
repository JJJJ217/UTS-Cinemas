//
//  MovieManager.swift
//  UTS Cinemas
//
//  Created by Jiaming Huang on 29/4/2026.
//


import Foundation

@MainActor
class MovieManager: ObservableObject {
    static let shared = MovieManager()

    @Published var nowShowing: [TMDBMovie] = []
    @Published var upcoming: [TMDBMovie] = []
    @Published var isLoading = false
    @Published var errorMessage: String?

    private let apiKey = Key.tmdbAPIKey
    private let baseURL = "https://api.themoviedb.org/3"

    private init() {}

    func fetchMovies() async {
        isLoading = true
        errorMessage = nil

        async let nowShowingResult = fetch(endpoint: "/movie/now_playing")
        async let upcomingResult = fetch(endpoint: "/movie/upcoming")

        nowShowing = (try? await nowShowingResult) ?? []
        upcoming = (try? await upcomingResult) ?? []

        isLoading = false
    }

    private func fetch(endpoint: String) async throws -> [TMDBMovie] {
        guard let url = URL(string: "\(baseURL)\(endpoint)?api_key=\(apiKey)&region=AU") else {
            throw URLError(.badURL)
        }

        let (data, _) = try await URLSession.shared.data(from: url)
        let response = try JSONDecoder().decode(TMDBResponse.self, from: data)
        return response.results
    }
}
