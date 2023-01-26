//
//  APIRequest.swift
//  TMDB Viewer
//
//  Created by Sergey Slobodenyuk on 2023-01-19.
//

import Foundation

/// REST API requests
protocol APIRequestProtocol<Resource>: NetworkRequest {
    associatedtype Resource: APIResource
    
    var resource: Resource { get }
}

/// REST API requests concrete class
class APIRequest<Resource: APIResource>: APIRequestProtocol {

    let session: URLSessionProtocol
    let resource: Resource
    
    init(resource: Resource, session: URLSessionProtocol = URLSession.shared) {
        self.session = session
        self.resource = resource
    }
}

extension APIRequest: NetworkRequest {
    
    func execute(withCompletion completion: @escaping (Resource.ModelType?) -> Void) {
        load(resource.url, withCompletion: completion)
    }

    func decode(_ data: Data) -> Resource.ModelType? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .formatted(dateFormatter)
        var model: Resource.ModelType? = nil
        do {
            model = try decoder.decode(Resource.ModelType.self, from: data)
        } catch {
            print(error)
        }
        return model
    }
}
