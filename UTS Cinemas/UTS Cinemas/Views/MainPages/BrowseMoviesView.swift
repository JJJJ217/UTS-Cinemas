//
//  BrowseMoviesView.swift
//  UTS Cinemas
//
//  Created by Jiaming Huang on 5/5/2026.
//

import SwiftUI

struct BrowseMoviesView: View {
    var body: some View {
        NavigationStack {
            VStack {
                Text("Browse Movies")
                    .font(.largeTitle)
                    .foregroundStyle(.secondary)
            }
            .navigationTitle("Browse Movies")
        }
    }
}

#Preview {
    BrowseMoviesView()
}
