//
//  MovieListViewModelTests.swift
//  TMDB Viewer Tests
//
//  Created by Sergey Slobodenyuk on 2023-01-26.
//

import XCTest
@testable import TMDB_Viewer

final class MovieListViewModelTests: XCTestCase {

    class URLSessionMock: URLSessionProtocol {
        class DataTaskMock: URLSessionDataTask {
            override func resume() { }
        }
        
        func dataTask(with url: URL, completionHandler: @escaping @Sendable (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask {
            defer { completionHandler(nil, nil, nil) }
            return DataTaskMock()
        }
    }
    
    class EmptyAPIRequestMock: APIRequestProtocol {
        typealias Resource = MovieListResource
        
        var resource: MovieListResource
        let session: URLSessionProtocol
        
        init() {
            self.resource = MovieListResource()
            self.session = URLSessionMock()
        }
        
        func execute(withCompletion completion: @escaping (MovieList?) -> Void) { }
        func decode(_ data: Data) -> MovieList? { nil }
    }
    
    class SimpleAPIRequestMock: APIRequestProtocol {
        typealias Resource = MovieListResource
        
        var resource: MovieListResource
        let session: URLSessionProtocol
        
        init() {
            self.resource = MovieListResource()
            self.session = URLSessionMock()
        }
        
        func execute(withCompletion completion: @escaping (MovieList?) -> Void) {
            completion(
                MovieList(
                    movies: Array(
                        repeating: Movie(id: Int.random(in: 1..<1000000), title: "Some title", imageURL: nil),
                        count: 20
                    ),
                    page: 1,
                    pageCount: 10,
                    movieCount: 200
                )
            )
        }
        
        func decode(_ data: Data) -> MovieList? { nil }
    }
    
    let testGenre = Genre(id: 123, name: "Genre name")
    

    func test_InitialState_WithEmptyCollection() {
        
        let sut = MovieListViewModel(genre: testGenre, request: EmptyAPIRequestMock())
        
        XCTAssertEqual(sut.movies.count, 0)
    }
    
    func test_Init_PopulatesCollection() {
        
        let sut = MovieListViewModel(genre: testGenre, request: SimpleAPIRequestMock())
        
        XCTAssertEqual(sut.movies.count, 20)
    }
    
    func test_FetchMovies_PopulatesCollection() {
        
        let sut = MovieListViewModel(genre: testGenre, request: SimpleAPIRequestMock())
        
        sut.fetchMovies()
        
        XCTAssertEqual(sut.movies.count, 20 + 20)   // init() + fetchMovies()
    }
    
    func test_FetchMovies_WhenNoInternet_EmptyCollection() {
        
        class APIRequestMock: APIRequestProtocol {
            typealias Resource = MovieListResource
            
            var resource: MovieListResource
            let session: URLSessionProtocol
            let expectation: XCTestExpectation
            
            init(expectation: XCTestExpectation) {
                self.resource = MovieListResource()
                self.session = URLSessionMock()
                self.expectation = expectation
            }
            
            func execute(withCompletion completion: @escaping (MovieList?) -> Void) {
                DispatchQueue.main.asyncAfter(deadline: .now() + 10) {
                    self.expectation.fulfill()
                    completion(nil)
                }
            }
            
            func decode(_ data: Data) -> MovieList? { nil }
        }
        
        let expectation = XCTestExpectation(description: "Returned empty collection")
        let sut = MovieListViewModel(genre: testGenre, request: APIRequestMock(expectation: expectation))
        
        sut.fetchMovies()
        
        wait(for: [expectation], timeout: 12)   // already got response
        XCTAssertEqual(sut.movies.count, 0)     // still empty collection
    }
    
    func test_PrepareMovie_IfIndexLow_NoPopulating() {
        
        let sut = MovieListViewModel(genre: testGenre, request: SimpleAPIRequestMock())
        
        sut.prepareMovie(index: 5)
        
        XCTAssertEqual(sut.movies.count, 20)
    }
    
    func test_PrepareMovie_IfIndexHigh_PopulatesCollection() {
        
        let sut = MovieListViewModel(genre: testGenre, request: SimpleAPIRequestMock())
        
        sut.prepareMovie(index: 12)
        
        XCTAssertEqual(sut.movies.count, 20 + 20)
    }

}
