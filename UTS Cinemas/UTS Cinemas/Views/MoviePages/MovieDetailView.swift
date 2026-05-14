import SwiftUI

struct MovieDetailView: View {
    let movie: TMDBMovie
    let isUpcoming: Bool
    @StateObject private var movieManager = MovieManager.shared
    @State private var selectedMovieForBooking: UUID? = nil
    @State private var detailedMovie: TMDBMovie? = nil
    @State private var selectedShowtime: Date? = nil

    private var todayShowtimes: [Date] {
        let calendar = Calendar.current
        let now = Date()
        let times = [(18, 15), (21, 30)]
        return times.compactMap { (hour, minute) in
            let date = calendar.date(bySettingHour: hour, minute: minute, second: 0, of: now)
            return date.flatMap { $0 > now ? $0 : nil }
        }
    }

    private var tomorrowShowtimes: [Date] {
        let calendar = Calendar.current
        let tomorrow = calendar.date(byAdding: .day, value: 1, to: Date())!
        let times = [(13, 0), (16, 30), (19, 45), (22, 15)]
        return times.compactMap { (hour, minute) in
            calendar.date(bySettingHour: hour, minute: minute, second: 0, of: tomorrow)
        }
    }

    private let timeFormatter: DateFormatter = {
        let f = DateFormatter()
        f.dateFormat = "h:mm a"
        return f
    }()

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

                    let displayMovie = detailedMovie ?? movie

                    HStack(spacing: 16) {
                        HStack(spacing: 4) {
                            Image(systemName: "star.fill")
                                .foregroundStyle(.yellow)
                            Text(movie.formattedRating)
                                .fontWeight(.semibold)
                        }
                        if let runtime = displayMovie.runtime, runtime > 0 {
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
                        Divider()

                        VStack(alignment: .leading, spacing: 12) {
                            Text("Showtimes")
                                .font(.headline)

                            if !todayShowtimes.isEmpty {
                                Text("Today")
                                    .font(.subheadline)
                                    .foregroundStyle(.secondary)

                                ScrollView(.horizontal, showsIndicators: false) {
                                    HStack(spacing: 8) {
                                        ForEach(todayShowtimes, id: \.self) { time in
                                            showtimeButton(time: time)
                                        }
                                    }
                                }
                            }

                            Text("Tomorrow")
                                .font(.subheadline)
                                .foregroundStyle(.secondary)

                            ScrollView(.horizontal, showsIndicators: false) {
                                HStack(spacing: 8) {
                                    ForEach(tomorrowShowtimes, id: \.self) { time in
                                        showtimeButton(time: time)
                                    }
                                }
                            }
                        }

                        Button {
                            if let showtime = selectedShowtime {
                                bookTMDBMovie(showtime: showtime)
                            }
                        } label: {
                            Text("Book Tickets")
                                .font(.headline)
                                .foregroundStyle(.white)
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 16)
                                .background(
                                    RoundedRectangle(cornerRadius: 14, style: .continuous)
                                        .fill(selectedShowtime == nil ? .gray : .red)
                                )
                        }
                        .disabled(selectedShowtime == nil)
                        .padding(.top, 8)
                    }
                }
                .padding(20)
            }
            .task(id: movie.id) {
                await fetchDetails()
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

    private func showtimeButton(time: Date) -> some View {
        let isSelected = selectedShowtime == time
        return Button {
            selectedShowtime = time
        } label: {
            Text(timeFormatter.string(from: time))
                .font(.subheadline)
                .fontWeight(.medium)
                .padding(.horizontal, 16)
                .padding(.vertical, 8)
                .background(
                    RoundedRectangle(cornerRadius: 8)
                        .fill(isSelected ? .red : .clear)
                        .stroke(isSelected ? Color.red : Color.gray.opacity(0.4), lineWidth: 1)
                )
                .foregroundStyle(isSelected ? .white : .primary)
        }
    }

    private func bookTMDBMovie(showtime: Date) {
        if let existing = movieManager.movies.first(where: { $0.title == movie.title && $0.showtime == showtime }) {
            selectedMovieForBooking = existing.id
        } else {
            let newMovie = Movie(
                title: movie.title,
                genre: "Now Showing",
                durationMinutes: detailedMovie?.runtime ?? movie.runtime ?? 120,
                rating: .m,
                posterImageName: "",
                description: movie.overview,
                location: "UTS Cinemas",
                showtime: showtime,
                trailerURL: ""
            )
            movieManager.movies.append(newMovie)
            movieManager.saveMovies()
            selectedMovieForBooking = newMovie.id
        }
    }

    private func fetchDetails() async {
        guard let url = URL(string: "https://api.themoviedb.org/3/movie/\(movie.id)?api_key=\(Key.tmdbAPIKey)") else { return }
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            detailedMovie = try JSONDecoder().decode(TMDBMovie.self, from: data)
        } catch {
            print("Failed to fetch movie details:", error)
        }
    }
}
