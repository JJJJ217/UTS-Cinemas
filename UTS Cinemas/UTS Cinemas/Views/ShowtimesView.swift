//
//  ShowtimeSelectionView.swift
//  UTS Cinemas
//
//  Created by Ameer Ali on 4/5/2026.
//

import SwiftUI

struct ShowtimesView: View {
    let movie: TMDBMovie
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationStack {
            VStack {
                Text("Showtimes coming soon")
                    .font(.headline)
                    .foregroundStyle(.secondary)
            }
            .navigationTitle(movie.title)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Done") { dismiss() }
                }
            }
        }
    }
}
