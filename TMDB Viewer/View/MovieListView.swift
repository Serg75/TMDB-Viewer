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
        ScrollView(.vertical, showsIndicators: true) {
            Section(footer: footer()) {
                VStack {
                    LazyVStack(alignment: .leading) {
                        ForEach(Array(viewModel.movies.enumerated()), id: \.offset) { index, movie in
                            HStack {
                                MovieView(viewModel: movie)
                                    .onAppear {
                                        if !viewModel.isEnd {
                                            DispatchQueue.global(qos: .userInitiated).async {
                                                viewModel.prepareMovie(index: index)
                                            }
                                        }
                                    }
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
        .navigationBarTitleDisplayMode(.inline)
    }
    
    @ViewBuilder
    func footer() -> some View {
        if viewModel.isEnd {
            Text("End")
        } else {
            ProgressView()
        }
    }
}

struct MovieListView_Previews: PreviewProvider {
    static var previews: some View {
        MovieListView(genre: Genre(id: 28, name: "Action"))
    }
}
