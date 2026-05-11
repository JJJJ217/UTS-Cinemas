import SwiftUI

struct MovieDetailView: View {
    let movie: TMDBMovie
    let isUpcoming: Bool
    @StateObject private var movieManager = MovieManager.shared
    @State private var selectedMovieForBooking: UUID? = nil

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 0) {
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
                    Text(movie.title)
                        .font(.title)
                        .fontWeight(.bold)

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

                    VStack(alignment: .leading, spacing: 8) {
                        Text("Synopsis")
                            .font(.headline)
                        Text(movie.overview)
                            .font(.body)
                            .foregroundStyle(.secondary)
                            .lineSpacing(4)
                    }

                    if !isUpcoming {
                        Button {
                            bookTMDBMovie()
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
                }
                .padding(20)
            }
        }
        .ignoresSafeArea(edges: .top)
        .navigationBarTitleDisplayMode(.inline)
        .fullScreenCover(isPresented: Binding(
            get: { selectedMovieForBooking != nil },
            set: { if !$0 { selectedMovieForBooking = nil } }
        )) {
            if let movieId = selectedMovieForBooking {
                NewBookingView(initialMovieId: movieId)
            }
        }
    }

    private func bookTMDBMovie() {
        if let existing = movieManager.movies.first(where: { $0.title == movie.title }) {
            selectedMovieForBooking = existing.id
        } else {
            let newMovie = Movie(
                title: movie.title,
                genre: "Now Showing",
                durationMinutes: movie.runtime ?? 120,
                rating: .m,
                posterImageName: "",
                description: movie.overview,
                location: "UTS Cinemas",
                showtime: Calendar.current.date(byAdding: .day, value: 1, to: Date()) ?? Date(),
                trailerURL: ""
            )
            movieManager.movies.append(newMovie)
            movieManager.saveMovies()
            selectedMovieForBooking = newMovie.id
        }
    }
}
