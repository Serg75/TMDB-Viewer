//
//  NetworkMocks.swift
//  TMDB ViewerTests
//
//  Created by Sergey Slobodenyuk on 2023-01-22.
//

import XCTest
@testable import TMDB_Viewer

struct ModelMock: Decodable, Equatable {
    let count: Int
    let items: [ItemMock]
    
    static func == (lhs: ModelMock, rhs: ModelMock) -> Bool {
        lhs.count == rhs.count && lhs.items == rhs.items
    }
}

struct ItemMock: Decodable, Equatable {
    let id: Int
    let some_bool: Bool
    let some_path: String
    let some_array: [Int]
    let some_string: String
    let another_num: Double
    let some_date: Date
}

struct ResourceMock: APIResource {
    typealias ModelType = ModelMock

    var url: URL
    var methodPath: String
    
    init(url: URL, methodPath: String = "/some_method") {
        self.url = url
        self.methodPath = methodPath
    }
}
