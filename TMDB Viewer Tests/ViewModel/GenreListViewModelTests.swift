//
//  GenreListViewModelTests.swift
//  TMDB Viewer Tests
//
//  Created by Sergey Slobodenyuk on 2023-01-26.
//

import Foundation

import XCTest
@testable import TMDB_Viewer

final class GenreListViewModelTests: XCTestCase {
    
    class URLSessionMock: URLSessionProtocol {
        class DataTaskMock: URLSessionDataTask {
            override func resume() { }
        }

        func dataTask(with url: URL, completionHandler: @escaping @Sendable (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask {
            defer { completionHandler(nil, nil, nil) }
            return DataTaskMock()
        }
    }
    
    func test_InitialState_WithEmptyCollection() {
        
        class APIRequestMock: APIRequestProtocol {
            let resource: GenreListResource
            let session: URLSessionProtocol
            
            init() {
                self.resource = GenreListResource()
                self.session = URLSessionMock()
            }

            func execute(withCompletion completion: @escaping (GenreList?) -> Void) { }
            func decode(_ data: Data) -> GenreList? { nil }
        }
        
        let sut = GenreListViewModel(request: APIRequestMock())
        
        XCTAssertEqual(sut.genres.count, 0)
    }

    func test_FetchGenres_PopulatesCollection() {
        
        class APIRequestMock: APIRequestProtocol {
            let resource: GenreListResource
            let session: URLSessionProtocol
            
            init() {
                self.resource = GenreListResource()
                self.session = URLSessionMock()
            }

            func execute(withCompletion completion: @escaping (GenreList?) -> Void) {
                completion(
                    GenreList(genres: Array(repeating: Genre(id: Int.random(in: 1..<1000000), name: ""), count: 10))
                )
            }
            
            func decode(_ data: Data) -> GenreList? { nil }
        }
        
        let sut = GenreListViewModel(request: APIRequestMock())
        
        sut.fetchGenres(clearCache: true)
        
        XCTAssertEqual(sut.genres.count, 10)
    }

    func test_FetchGenres_WhenNoInternet_EmptyCollection() {
        
        class APIRequestMock: APIRequestProtocol {

            let resource: GenreListResource
            let session: URLSessionProtocol
            let expectation: XCTestExpectation
            
            init(expectation: XCTestExpectation) {
                self.resource = GenreListResource()
                self.session = URLSessionMock()
                self.expectation = expectation
            }

            func execute(withCompletion completion: @escaping (GenreList?) -> Void) {
                DispatchQueue.main.asyncAfter(deadline: .now() + 10) {
                    self.expectation.fulfill()
                    completion(nil)
                }
            }
            
            func decode(_ data: Data) -> GenreList? { nil }
        }
        
        let expectation = XCTestExpectation(description: "Returned empty collection")
        let sut = GenreListViewModel(request: APIRequestMock(expectation: expectation))
        
        sut.fetchGenres(clearCache: true)
        
        wait(for: [expectation], timeout: 12)   // already got response
        XCTAssertEqual(sut.genres.count, 0)     // still empty collection
    }
}
