//
//  GenreListView.swift
//  TMDB Viewer
//
//  Created by Sergey Slobodenyuk on 2023-01-19.
//

import SwiftUI

struct GenreListView: View {
    @StateObject private var viewModel = GenreListViewModel()
    
    var body: some View {
        NavigationView {
            List(viewModel.genres) { genre in
                NavigationLink(destination: MovieListView(genre: genre)) {
                    VStack {
                        Text(genre.name ?? "Unknown")
                    }
                }
            }
            .navigationTitle("Tmdb")
            .onAppear {
                viewModel.fetchGenres()
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        GenreListView()
    }
}
