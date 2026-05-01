//
//  HomePageView.swift
//  UTS Cinemas
//
//  Created by Jiaming Huang on 1/5/2026.
//

import SwiftUI

struct HomePageView: View {
    // Sample data for demo
    private let nowShowingTitles = [
        "Dune: Part Two",
        "Civil War",
        "Kung Fu Panda 4",
        "The Fall Guy"
    ]
    // Sample data for demo
    private let upcomingTitles = [
        "Inside Out 2",
        "Furiosa",
        "A Quiet Place: Day One",
        "Deadpool & Wolverine"
    ]

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    nowShowingSection
                    upcomingSection
                    quickActions
                }
                .padding(.horizontal)
                .padding(.vertical, 16)
            }
            .navigationTitle("UTS Cinemas")
        }
    }

    private var nowShowingSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Now Showing")
                .font(.headline)

            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 12) {
                    ForEach(nowShowingTitles, id: \.self) { title in
                        movieCard(title: title)
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
                    ForEach(upcomingTitles, id: \.self) { title in
                        movieCard(title: title)
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
    
    // simplified action card for demo
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
    // simplified movie card for demo
    private func movieCard(title: String) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            RoundedRectangle(cornerRadius: 12, style: .continuous)
                .fill(.gray.opacity(0.2))
                .frame(width: 140, height: 190)
                .overlay(
                    Image(systemName: "film")
                        .font(.title)
                        .foregroundStyle(.gray)
                )

            Text(title)
                .font(.subheadline)
                .fontWeight(.semibold)
                .lineLimit(2)
                .frame(width: 140, alignment: .leading)

            Text("2h 10m • PG")
                .font(.caption)
                .foregroundStyle(.secondary)
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
