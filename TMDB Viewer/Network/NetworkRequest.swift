//
//  NetworkRequest.swift
//  TMDB Viewer
//
//  Created by Sergey Slobodenyuk on 2023-01-19.
//

import Foundation

/// Generic type of requests to any web resourse
protocol NetworkRequest: AnyObject {
    
    /// Returning type
    associatedtype ModelType
    
    var session: URLSessionProtocol { get }
    
    /// Execute network request
    /// - Parameters:
    ///     - completion:   Callback to pass the processed data back to the caller
    func execute(withCompletion completion: @escaping (ModelType?) -> Void)
    
    /// Transform data we receive into a model type
    func decode(_ data: Data) -> ModelType?
}

extension NetworkRequest {
    
    /// Start the asynchronous data transfer.
    /// Call this function from ``execute`` function in concrete protocol implementation.
    func load(_ url: URL, withCompletion completion: @escaping (ModelType?) -> Void) {
	    let task = session.dataTask(with: url) { [weak self] (data, _ , _) -> Void in
    	    guard let data = data, let value = self?.decode(data) else {
	    	    DispatchQueue.main.async { completion(nil) }
	    	    return
    	    }
    	    DispatchQueue.main.async { completion(value) }
	    }
	    task.resume()
    }
}

// ===================

/// Protocol to wrap URLSession class from Foundation.
/// - Note: It is used for URLSession mocking.
protocol URLSessionProtocol {
    func dataTask(with url: URL, completionHandler: @escaping @Sendable (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask
}

// Make Foundation URLSession class conform to the protocol
extension URLSession: URLSessionProtocol { }
