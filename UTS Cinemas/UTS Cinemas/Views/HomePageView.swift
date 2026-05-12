//
//  HomePageView.swift
//  UTS Cinemas
//
//  Created by Jiaming Huang on 1/5/2026.
//
import SwiftUI

struct HomePageView: View {
    @StateObject private var movieManager = MovieManager.shared
    @StateObject private var authManager = AuthManager.shared
    @StateObject private var bookingManager = BookingManager.shared

    @State private var showAddSheet = false
    @State private var movieToEdit: Movie? = nil
    @State private var showBookingSheet = false
    @State private var bookingToEdit: Booking? = nil
    @State private var selectedMovieForBooking: UUID? = nil

    private var nowShowingMovies: [Movie] {
        movieManager.movies.filter { $0.isNowShowing }
    }

    private var upcomingMovies: [Movie] {
        movieManager.movies.filter { $0.isUpcoming }
    }

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading) {
                    Text("UTS Cinemas")
                        .bold()
                        .font(.title)
                        .padding(.horizontal)
                        .frame(maxWidth: .infinity, alignment: .center)

                    Spacer()

                    if authManager.currentUser?.role == .admin {
                        adminControls
                            .padding(.horizontal)
                    }

                    // TMDB Now Showing
                    if !movieManager.nowShowing.isEmpty {
                        tmdbMoviesSection(title: "Now Showing", movies: movieManager.nowShowing)
                            .padding(.bottom, 12)
                    } else if movieManager.isLoading {
                        ProgressView("Loading movies...")
                            .frame(maxWidth: .infinity)
                            .padding()
                    }

                    // TMDB Upcoming
                    if !movieManager.upcoming.isEmpty {
                        tmdbMoviesSection(title: "Upcoming", movies: movieManager.upcoming)
                            .padding(.bottom, 12)
                    }

                    // Local admin-created movies
                    if !nowShowingMovies.isEmpty {
                        moviesSection(title: "Now Showing (Local)", movies: nowShowingMovies)
                            .padding(.bottom, 12)
                    }

                    if !upcomingMovies.isEmpty {
                        moviesSection(title: "Upcoming (Local)", movies: upcomingMovies)
                            .padding(.bottom, 12)
                    }

                    bookingsSection
                }
                .padding(.vertical)
            }
            .task {
                if movieManager.nowShowing.isEmpty {
                    await movieManager.fetchMovies()
                }
            }
            .sheet(isPresented: $showAddSheet) {
                MovieEditView()
            }
            .sheet(item: $movieToEdit) { movie in
                MovieEditView()
            }
            .sheet(isPresented: $showBookingSheet) {
                BookingEditView(bookingToEdit: bookingToEdit)
            }
            .fullScreenCover(isPresented: Binding(
                get: { selectedMovieForBooking != nil },
                set: { if !$0 { selectedMovieForBooking = nil } }
            )) {
                if let movieId = selectedMovieForBooking {
                    NewBookingView(initialMovieId: movieId)
                }
            }
        }
    }

    // TMDB movie section
    private func tmdbMoviesSection(title: String, movies: [TMDBMovie]) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(title)
                .font(.headline)
                .padding(.horizontal)

            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 12) {
                    ForEach(movies) { movie in
                        NavigationLink(destination: MovieDetailView(movie: movie, isUpcoming: title == "Upcoming")) {
                            tmdbMovieCard(movie: movie)
                        }
                        .buttonStyle(.plain)
                    }
                }
                .padding(.horizontal, 12)
            }
        }
    }

    private func tmdbMovieCard(movie: TMDBMovie) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            AsyncImage(url: movie.posterURL) { image in
                image
                    .resizable()
                    .scaledToFill()
            } placeholder: {
                RoundedRectangle(cornerRadius: 12)
                    .fill(.gray.opacity(0.3))
                    .overlay(ProgressView())
            }
            .frame(width: 140, height: 200)
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
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 12, style: .continuous)
                .fill(.ultraThinMaterial)
        )
    }

    // Their existing sections below unchanged
    private var adminControls: some View {
        HStack {
            Text("Admin Controls")
                .font(.headline)
            Spacer()
            Button(action: { showAddSheet = true }) {
                Label("Add Movie", systemImage: "plus")
            }
            .buttonStyle(.borderedProminent)
        }
        .padding(.bottom)
    }

    private var bookingsSection: some View {
        VStack(alignment: .leading) {
            let myBookings = bookingManager.userBookings(customerId: authManager.currentUser?.id)
            if !myBookings.isEmpty {
                Text("My Bookings")
                    .font(.headline)
                    .padding(.horizontal)

                ForEach(myBookings) { booking in
                    HStack {
                        VStack(alignment: .leading) {
                            let movie = movieManager.movies.first(where: { $0.id == booking.movieId })
                            Text(movie?.title ?? "Unknown Movie")
                                .fontWeight(.semibold)
                            Text("Seats: \(booking.seats.joined(separator: ", "))")
                                .font(.caption)
                                .foregroundStyle(.secondary)
                            Text("Location: \(movie?.location ?? "N/A")")
                                .font(.caption)
                                .foregroundStyle(.secondary)
                            if let showtime = movie?.showtime {
                                Text("Showtime: ")
                                    .font(.caption)
                                    .foregroundStyle(.secondary)
                                + Text(showtime, format: .dateTime.month().day().hour().minute())
                                    .font(.caption)
                                    .foregroundStyle(.secondary)
                            }
                        }
                        Spacer()
                        Button("Edit") {
                            bookingToEdit = booking
                            showBookingSheet = true
                        }
                        .buttonStyle(.bordered)

                    }
                    .padding()
                    .background(Color.gray.opacity(0.1))
                    .cornerRadius(12)
                    .padding(.horizontal)
                }
            }
        }
    }

    private func moviesSection(title: String, movies: [Movie]) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(title)
                .font(.headline)
                .padding(.horizontal)

            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 12) {
                    ForEach(movies) { movie in
                        NavigationLink(destination: LocalMovieDetailView(movie: movie)) {
                            movieCard(movie: movie)
                        }
                        .buttonStyle(.plain)
                    }
                }
                .padding(.horizontal, 12)
            }
        }
    }

    private func movieCard(movie: Movie) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            RoundedRectangle(cornerRadius: 12, style: .continuous)
                .fill(.gray.opacity(0.3))
                .frame(width: 140, height: 200)
                .overlay(
                    Image(movie.posterImageName.isEmpty ? "film" : movie.posterImageName)
                        .resizable()
                        .scaledToFill()
                        .frame(width: 140, height: 200)
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                )

            Text(movie.title)
                .font(.subheadline)
                .fontWeight(.semibold)
                .lineLimit(2)
                .frame(width: 140, alignment: .leading)

            Text("\(movie.durationMinutes)m • \(movie.rating.rawValue.uppercased())")
                .font(.caption)
                .foregroundStyle(.secondary)

            Text(movie.location)
                .font(.caption2)
                .foregroundStyle(.secondary)

            Text(movie.showtime, format: .dateTime.month().day().hour().minute())
                .font(.caption2)
                .foregroundStyle(.secondary)

            let isUpcoming = movie.isUpcoming
            Button(isUpcoming ? "Pre-Book" : "Book Now") {
                selectedMovieForBooking = movie.id
            }
            .tint(isUpcoming ? .orange : .blue)
            .buttonStyle(.borderedProminent)
            .font(.caption)
            .foregroundStyle(.black)
            .padding(.top, 8)
            .padding(.bottom, 8)

            if authManager.currentUser?.role == .admin {
                HStack {
                    Button("Edit") { movieToEdit = movie }
                        .font(.caption)
                        .buttonStyle(.bordered)

                    Button(role: .destructive) {
                        movieManager.deleteMovie(movie)
                    } label: {
                        Text("Delete")
                    }
                    .font(.caption)
                    .buttonStyle(.bordered)
                }
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 12, style: .continuous)
                .fill(.ultraThinMaterial)
        )
    }
}

#Preview {
    HomePageView()
}
