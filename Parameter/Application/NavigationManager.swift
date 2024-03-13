//
//  NavigationManager.swift
//  Parameter
//
//  Created by Abhinay Pratap on 13/03/24.
//

import Foundation
import OSLog

class NavigationManager {
    private var screens = [String: Screen]()
    private let subsystem = Bundle.main.bundleIdentifier

    func fetch(completion: (Screen) -> Void) {

        guard let subsystem else { return }
        let logger = Logger(subsystem: subsystem, category: "navigation-manager")

        guard let url = URL(string: "http://localhost:8090/index.json") else {
            logger.error("Failed to load URL")
            return
        }

        do {
            let data = try Data(contentsOf: url)
            let app = try JSONDecoder().decode(Application.self, from: data)
            for screen in app.screens {
                screens[screen.id] = screen
            }
            completion(app.screens[0])
        } catch let error {
            logger.error("\(error.localizedDescription)")
        }
    }
}
