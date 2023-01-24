//
//  MovieListView.swift
//  TMDB Viewer
//
//  Created by Sergey Slobodenyuk on 2023-01-23.
//

import SwiftUI

struct MovieListView: View {
    @StateObject private var viewModel: MovieListViewModel
    private var genre: Genre
    
    init(genre: Genre) {
        self.genre = genre
        let viewModel = MovieListViewModel(genre: genre)
        _viewModel = StateObject(wrappedValue: viewModel)
    }
    
    var body: some View {
        ScrollView(.vertical) {
            VStack {
                if viewModel.isLoading {
                    ProgressView()
                        .frame(maxWidth: .infinity, alignment: .center)
                } else {
                    VStack(alignment: .leading) {
                        ForEach(viewModel.movies) { movie in
                            HStack {
                                MovieView(viewModel: movie)
                            }
                        }
                    }
                    .frame(
                        maxWidth: .infinity,
                        alignment: .leading
                    )
                    .padding(.horizontal, 10.0)
                }
            }
        }
        .navigationTitle(genre.name ?? "Unknown")
        .onAppear {
            viewModel.fetchMovies()
        }
    }
}

struct MovieListView_Previews: PreviewProvider {
    static var previews: some View {
        MovieListView(genre: Genre(id: 28, name: "Action"))
    }
}
