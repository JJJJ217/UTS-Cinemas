import SwiftUI

struct HomePageView: View {
    @StateObject private var movieManager = MovieManager.shared

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    if movieManager.isLoading {
                        ProgressView("Loading movies...")
                            .frame(maxWidth: .infinity)
                            .padding(.top, 40)
                    } else {
                        nowShowingSection
                        upcomingSection
                        quickActions
                    }
                }
                .padding(.horizontal)
                .padding(.vertical, 16)
            }
            .navigationTitle("UTS Cinemas")
            .task {
                await movieManager.fetchMovies()
            }
        }
    }

    private var nowShowingSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Now Showing")
                .font(.headline)

            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 12) {
                    ForEach(movieManager.nowShowing) { movie in
                        movieCard(movie: movie)
                    }
                }
                .padding(.horizontal, 2)
            }
        }
    }

    private var upcomingSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Upcoming")
                .font(.headline)

            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 12) {
                    ForEach(movieManager.upcoming) { movie in
                        movieCard(movie: movie)
                    }
                }
                .padding(.horizontal, 2)
            }
        }
    }

    private var quickActions: some View {
        HStack(spacing: 12) {
            actionCard(title: "Browse Movies", systemImage: "popcorn")
            actionCard(title: "My Bookings", systemImage: "ticket")
        }
    }

    private func actionCard(title: String, systemImage: String) -> some View {
        VStack(spacing: 8) {
            Image(systemName: systemImage)
                .font(.title2)
            Text(title)
                .font(.subheadline)
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 14)
        .background(
            RoundedRectangle(cornerRadius: 12, style: .continuous)
                .fill(.gray.opacity(0.15))
        )
    }

    private func movieCard(movie: TMDBMovie) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            // Poster image
            AsyncImage(url: movie.posterURL) { image in
                image
                    .resizable()
                    .aspectRatio(contentMode: .fill)
            } placeholder: {
                RoundedRectangle(cornerRadius: 12)
                    .fill(.gray.opacity(0.2))
                    .overlay(
                        ProgressView()
                    )
            }
            .frame(width: 140, height: 190)
            .clipShape(RoundedRectangle(cornerRadius: 12))

            Text(movie.title)
                .font(.subheadline)
                .fontWeight(.semibold)
                .lineLimit(2)
                .frame(width: 140, alignment: .leading)

            HStack(spacing: 4) {
                Image(systemName: "star.fill")
                    .foregroundStyle(.yellow)
                    .font(.caption)
                Text(movie.formattedRating)
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
        }
        .padding(12)
        .background(
            RoundedRectangle(cornerRadius: 14, style: .continuous)
                .fill(.ultraThinMaterial)
        )
    }
}

#Preview {
    HomePageView()
}
