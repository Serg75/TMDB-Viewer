//
//  MovieListViewModel.swift
//  TMDB Viewer
//
//  Created by Sergey Slobodenyuk on 2023-01-23.
//

import Foundation

class MovieListViewModel: ObservableObject {
    private let genre: Genre
    private var movieModels: [Movie] = []
    
    private var page = 1
    
    @Published private(set) var movies: [MovieViewModel] = []
    @Published private(set) var isEnd = false
    private var isLoading = false

    private let request: (any APIRequestProtocol<MovieListResource>)!

    init(
        genre: Genre,
        request: any APIRequestProtocol<MovieListResource> = APIRequest(resource: MovieListResource())
    ) {
	    self.genre = genre
        self.request = request
        self.fetchMovies()
    }
    
    func fetchMovies() {
        guard !isLoading else { return }
        
        isLoading = true
        request.resource = MovieListResource(genre: genre, page: page)
        request.execute { [weak self] movieList in
            if let self = self, let movieList = movieList as? MovieList {
                self.isEnd = movieList.page >= movieList.pageCount
                let from = self.movieModels.count
                self.movieModels.append(contentsOf: movieList.movies)
                let to = self.movieModels.count
                self.movies.append(contentsOf: Array(repeating: MovieViewModel(movie: nil), count: movieList.movies.count))
                self.updateMovies(in: IndexSet(from..<to))
            }
        }
        isLoading = false
    }

    func prepareMovie(index: Int) {
        if index + 10 > movies.count {
            fetchMovies()
        }
    }

    func updateMovies(in positions: IndexSet) {
        for pos in positions {
            movies[pos] = MovieViewModel(movie: movieModels[pos])
        }
    }
}
