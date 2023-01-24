//
//  APIResource.swift
//  TMDB Viewer
//
//  Created by Sergey Slobodenyuk on 2023-01-19.
//

import Foundation

fileprivate let TMDB_URL = "https://api.themoviedb.org/3"
fileprivate let API_KEY = "6f83e26e82a37507bf29b27ff511f452"
fileprivate let LANGUAGE = "en-US"


/// REST API resource for making API request
protocol APIResource {
    
    /// Associated model type into which data needs to be converted
    associatedtype ModelType: Decodable

    /// Full URL for request
    var url: URL { get }
    
    /// URL method like '/genre/movie/list'
    var methodPath: String { get }
    
    /// Additional data
    var extraData: [String: String]? { get }
}

extension APIResource {
    var url: URL {
	    var components = URLComponents(string: TMDB_URL)!
	    components.path += methodPath
	    components.queryItems = [
    	    URLQueryItem(name: "api_key", value: API_KEY),
    	    URLQueryItem(name: "language", value: LANGUAGE)
	    ]
        if let extraData = extraData {
            for item in extraData {
                components.queryItems?.append(URLQueryItem(name: item.key, value: item.value))
            }
        }
	    return components.url!
    }
    
    var extraData: [String: String]? { nil }
}
