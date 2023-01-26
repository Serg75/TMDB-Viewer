//
//  GenreListViewModel.swift
//  TMDB Viewer
//
//  Created by Sergey Slobodenyuk on 2023-01-19.
//

import Foundation

fileprivate let GENRES_KEY = "genres"
fileprivate let DATE_KEY = "genres-date"
fileprivate let RETENTION_TIME: Double = 60 * 60 * 24   // 24h


class GenreListViewModel: ObservableObject {
    @Published private(set) var genres: [Genre] = []
    @Published private(set) var isLoading = false
    
    private let request: (any APIRequestProtocol<GenreListResource>)!
    private let defaults: UserDefaults
    
    init(
        request: any APIRequestProtocol<GenreListResource> = APIRequest(resource: GenreListResource()),
        defaults: UserDefaults = UserDefaults.standard
    ) {
        self.request = request
        self.defaults = defaults
    }
    
    func fetchGenres(clearCache: Bool = false) {
        
        clearOldCacheData(deleteAll: clearCache)
        
        if let genres = loadFromCache() {
            self.genres = genres
            return
        }
        
	    guard !isLoading else { return }
        
	    isLoading = true
	    request.execute { [weak self] genreList in
            if let self = self {
                self.genres = (genreList as? GenreList)?.genres ?? []
                self.isLoading = false
                self.saveToCache(self.genres)
            }
	    }
    }
    
    func saveToCache(_ genres: [Genre]) {
        let jsonEncoder = JSONEncoder()
        if let data = try? jsonEncoder.encode(genres) {
            defaults.set(data, forKey: GENRES_KEY)
            defaults.set(Date(), forKey: DATE_KEY)
        }
    }
    
    func loadFromCache() -> [Genre]? {
        guard let data = defaults.object(forKey: GENRES_KEY) as? Data else { return nil }
        
        let jsonDecoder = JSONDecoder()
        return try? jsonDecoder.decode([Genre].self, from: data)
    }
        
    func clearOldCacheData(deleteAll: Bool) {
        let savedDate = defaults.object(forKey: DATE_KEY) as? Date

        if deleteAll || savedDate == nil || DateInterval(start: savedDate!, end: Date()).duration > RETENTION_TIME {
            defaults.removeObject(forKey: GENRES_KEY)
            defaults.removeObject(forKey: DATE_KEY)
        }
    }
}
