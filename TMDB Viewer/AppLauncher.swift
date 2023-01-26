//
//  AppLauncher.swift
//  TMDB Viewer
//
//  Created by Sergey Slobodenyuk on 2023-01-26.
//

import SwiftUI

@main
struct AppLauncher {
    static func main() throws {
        if NSClassFromString("XCTestCase") == nil {
            TMDB_ViewerApp.main()
        } else {
            TestApp.main()
        }
    }
}
