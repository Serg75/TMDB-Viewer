//
//  NetworkRequestTests.swift
//  TMDB Viewer Tests
//
//  Created by Sergey Slobodenyuk on 2023-01-22.
//

import XCTest
@testable import TMDB_Viewer

final class TMDB_Viewer_NerworkTests: XCTestCase {
    
    func testAPIRequest_WhenExecuted_CorrectURLShouldRequested() {

        class DataTaskMock: URLSessionDataTask {
            override func resume() { }
        }

        class URLSessionMock: URLSessionProtocol {
            var lastURL: URL?

            func dataTask(with url: URL, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask {
                defer { completionHandler(nil, nil, nil) }
                lastURL = url
                return DataTaskMock()
            }
        }

        // given
        let urlString = "https://www.someurl.com"
        let url = URL(string: urlString)!
        let session = URLSessionMock()
        let request = APIRequest(resource: ResourceMock(url: url), session: session)
        let expectation = XCTestExpectation(description: "Downloading some data.")
        
        // when
        request.execute { _ in
            XCTAssertEqual(URL(string: urlString), session.lastURL)
            expectation.fulfill()
        }
        
        // then
        wait(for: [expectation], timeout: 5)
    }
    
    func testAPIRequest_WhenExecuted_ResumeWasCalled() {

        class DataTaskMock: URLSessionDataTask {
            var completionHandler: (Data?, URLResponse?, Error?) -> Void
            var resumeWasCalled = false

            // stash away the completion handler so we can call it later
            init(completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) {
                self.completionHandler = completionHandler
            }

            override func resume() {
                // resume was called, so flip our boolean and call the completion
                resumeWasCalled = true
                completionHandler(nil, nil, nil)
            }
        }

        class URLSessionMock: URLSessionProtocol {
            var dataTask: DataTaskMock?

            func dataTask(with url: URL, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask {
                let newDataTask = DataTaskMock(completionHandler: completionHandler)
                dataTask = newDataTask
                return newDataTask
            }
        }

        // given
        let url = URL(string: "https://www.someurl.com")!
        let session = URLSessionMock()
        let request = APIRequest(resource: ResourceMock(url: url), session: session)
        let expectation = XCTestExpectation(description: "Downloading some data triggers resume()")

        // when
        request.execute { _ in
            XCTAssertTrue(session.dataTask?.resumeWasCalled ?? false)
            expectation.fulfill()
        }

        // then
        wait(for: [expectation], timeout: 5)
    }
    
    func testAPIRequest_WhenExecuted_CorrectDataReceived() {

        class URLSessionMock: URLSessionProtocol {
            var testData: Data?

            func dataTask(with url: URL, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask {
                defer {
                    completionHandler(testData, nil, nil)
                }

                return DataTaskMock()
            }
        }

        class DataTaskMock: URLSessionDataTask {
            override func resume() { }
        }
        
        // given
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        let modelItems = [
            ItemMock(
                id: 315162,
                some_bool: false,
                some_path: "/r9PkFnRUIthgBp2JZZzD380MWZy.jpg",
                some_array: [16, 28, 12, 35],
                some_string: "Puss in Boots discovers...",
                another_num: 9062.029,
                some_date: dateFormatter.date(from: "2022-12-07")!),
            ItemMock(
                id: 536554,
                some_bool: true,
                some_path: "/q2fY4kMXKoGv4CQf310MCxpXlRI.jpg",
                some_array: [878, 27, 35],
                some_string: "A brilliant toy company...",
                another_num: 2679.327,
                some_date: dateFormatter.date(from: "2022-12-28")!)
        ]
        let modelMock = ModelMock(count: 345, items: modelItems)
        
        let jsonResponse =
        """
        {
          "count": 345,
          "items": [
            {
              "some_bool": false,
              "some_path": "/r9PkFnRUIthgBp2JZZzD380MWZy.jpg",
              "some_array": [
                16,
                28,
                12,
                35
              ],
              "id": 315162,
              "some_string": "Puss in Boots discovers...",
              "another_num": 9062.029,
              "some_date": "2022-12-07"
            },
            {
              "some_bool": true,
              "some_path": "/q2fY4kMXKoGv4CQf310MCxpXlRI.jpg",
              "some_array": [
                878,
                27,
                35
              ],
              "id": 536554,
              "some_string": "A brilliant toy company...",
              "another_num": 2679.327,
              "some_date": "2022-12-28",
            }
          ]
        }
        """
        
        let url = URL(string: "https://www.someurl.com")!
        let session = URLSessionMock()
        session.testData = Data(jsonResponse.utf8)
        let request = APIRequest(resource: ResourceMock(url: url), session: session)
        let expectation = XCTestExpectation(description: "Downloading some data triggers resume()")

        // when
        request.execute { model in
            XCTAssertEqual(model, modelMock)
            expectation.fulfill()
        }

        // then
        wait(for: [expectation], timeout: 5)
    }
}
