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
    @Published private(set) var movies: [MovieViewModel] = []
    @Published private(set) var isLoading = false
    
    private var request: APIRequest<MovieListResource>?
    
    init(genre: Genre) {
	    self.genre = genre
    }
    
    func fetchMovies() {
        guard !isLoading else { return }
        isLoading = true
        let resource = MovieListResource(genre: genre, page: 1)
        let request = APIRequest(resource: resource)
        self.request = request
        request.execute { [weak self] movieList in
            self?.movieModels = movieList?.movies ?? []
            let n = (self?.movieModels.count)!
            self?.movies = Array(repeating: MovieViewModel(movie: nil), count: n)
            self?.updateMovies(in: IndexSet(0..<n))
            self?.isLoading = false
        }
    }
    
    func updateMovies(in positions: IndexSet) {
        for pos in positions {
            movies[pos] = MovieViewModel(movie: movieModels[pos])
        }
    }
}
