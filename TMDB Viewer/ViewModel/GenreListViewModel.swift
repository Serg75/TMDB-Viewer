//
//  GenreListViewModel.swift
//  TMDB Viewer
//
//  Created by Sergey Slobodenyuk on 2023-01-19.
//

import Foundation

class GenreListViewModel: ObservableObject {
    @Published private(set) var genres: [Genre] = []
    @Published private(set) var isLoading = false
    
    private var request: APIRequest<GenreListResource>?
    
    func fetchGenres() {
	    guard !isLoading else { return }
	    isLoading = true
	    let resource = GenreListResource()
	    let request = APIRequest(resource: resource)
	    self.request = request
	    request.execute { [weak self] genreList in
            self?.genres = genreList?.genres ?? []
    	    self?.isLoading = false
	    }
    }
}
