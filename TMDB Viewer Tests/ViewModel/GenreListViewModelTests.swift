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
    
    class SimpleAPIRequestMock: APIRequestProtocol {
        let resource: GenreListResource
        let session: URLSessionProtocol
        
        init() {
            self.resource = GenreListResource()
            self.session = URLSessionMock()
        }
        
        func execute(withCompletion completion: @escaping (GenreList?) -> Void) { }
        func decode(_ data: Data) -> GenreList? { nil }
    }
    
    let tenGenres: [Genre] = {
        Array(repeating: Genre(id: Int.random(in: 1..<1000000), name: ""), count: 10)
    }()
    
    func test_InitialState_WithEmptyCollection() {
        
        let sut = GenreListViewModel(request: SimpleAPIRequestMock())
        
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
    
    func test_FetchGenres_SavesCache() {
        
        class APIRequestMock: APIRequestProtocol {
            let resource: GenreListResource
            let session: URLSessionProtocol
            
            init() {
                self.resource = GenreListResource()
                self.session = URLSessionMock()
            }
            
            func execute(withCompletion completion: @escaping (GenreList?) -> Void) {
                completion(
                    GenreList(genres: (1..<10).map {
                        Genre(id: $0, name: "")
                    })
                )
            }
            
            func decode(_ data: Data) -> GenreList? { nil }
        }
        
        let defaults = UserDefaults(suiteName: "test")!
        let sut = GenreListViewModel(request: APIRequestMock(), defaults: defaults)
        defaults.removeObject(forKey: "genres")
        defaults.removeObject(forKey: "genres-date")
        
        sut.fetchGenres(clearCache: true)
        
        XCTAssertNotNil(defaults.object(forKey: "genres"))
        XCTAssertNotNil(defaults.object(forKey: "genres-date"))
    }
    
    func test_SaveCache_SavesProperDate() {
        
        let defaults = UserDefaults(suiteName: "test")!
        let sut = GenreListViewModel(request: SimpleAPIRequestMock(), defaults: defaults)
        
        sut.saveToCache(tenGenres)
        
        let date = defaults.object(forKey: "genres-date") as? Date
        XCTAssertNotNil(date)
        XCTAssertEqual(
            date!.timeIntervalSinceReferenceDate,
            Date().timeIntervalSinceReferenceDate,
            accuracy: 1
        )
    }
    
    func test_LoadCache_ReturnsSameDataAsSaveCache() {
        
        let defaults = UserDefaults(suiteName: "test")!
        let sut = GenreListViewModel(request: SimpleAPIRequestMock(), defaults: defaults)
        
        sut.saveToCache(tenGenres)
        
        let loadedGenres = sut.loadFromCache()
        
        XCTAssertEqual(tenGenres, loadedGenres)
    }
    
    func test_ClearOldCacheData_IfDeleteAll_ClearsCache() {
        
        let defaults = UserDefaults(suiteName: "test")!
        let sut = GenreListViewModel(request: SimpleAPIRequestMock(), defaults: defaults)
        
        sut.saveToCache(tenGenres)
        
        sut.clearOldCacheData(deleteAll: true)
        
        XCTAssertNil(defaults.object(forKey: "genres"))
        XCTAssertNil(defaults.object(forKey: "genres-date"))
    }
    
    func test_ClearOldCacheData_IfNoDateInCache_ClearsCache() {
        
        let defaults = UserDefaults(suiteName: "test")!
        let sut = GenreListViewModel(request: SimpleAPIRequestMock(), defaults: defaults)
        
        sut.saveToCache(tenGenres)
        defaults.removeObject(forKey: "genres-date")

        sut.clearOldCacheData(deleteAll: false)
        
        XCTAssertNil(defaults.object(forKey: "genres"))
        XCTAssertNil(defaults.object(forKey: "genres-date"))
    }

    func test_ClearOldCacheData_IfOldData_ClearsCache() {
        
        let defaults = UserDefaults(suiteName: "test")!
        let sut = GenreListViewModel(request: SimpleAPIRequestMock(), defaults: defaults)
        
        sut.saveToCache(tenGenres)
        // set date older than 24h and 10 sec
        defaults.set(Date() - (60 * 60 * 24 + 10), forKey: "genres-date")

        sut.clearOldCacheData(deleteAll: false)
        
        XCTAssertNil(defaults.object(forKey: "genres"))
        XCTAssertNil(defaults.object(forKey: "genres-date"))
    }
}
