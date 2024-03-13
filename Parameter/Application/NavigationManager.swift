//
//  NavigationManager.swift
//  Parameter
//
//  Created by Abhinay Pratap on 13/03/24.
//

import AVKit
import SafariServices
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

    func execute(_ action: Action?, from viewController: UIViewController) {

        guard let action else { return }
        if let action = action as? AlertAction {
            let vc = UIAlertController(title: action.title, message: action.message, preferredStyle: .alert)
            vc.addAction(UIAlertAction(title: "OK", style: .default))
            viewController.present(vc, animated: true)
        } else if let action = action as? ShowWebsiteAction {
            let vc = SFSafariViewController(url: action.url)
            viewController.navigationController?.present(vc, animated: true)
        } else if let action = action as? ShowScreenAction {
            guard let screen = screens[action.id] else {
                fatalError("Attempting to show unknown screen: \(action.id)")
            }

            let vc = TableScreen(screen: screen)
            vc.navigationManager = self
            viewController.navigationController?.pushViewController(vc, animated: true)
        } else if let action = action as? PlayMovieAction {
            let player = AVPlayer(url: action.url)
            let playerViewController = AVPlayerViewController()
            playerViewController.player = player
            player.play()
            viewController.present(playerViewController, animated: true)
        } else if let action = action as? ShareAction {
            var items = [Any]()

            if let text = action.text { items.append(text) }
            if let url = action.url { items.append(url) }

            if items.isEmpty == false {
                let vc = UIActivityViewController(activityItems: items, applicationActivities: nil)
                viewController.present(vc, animated: true)
            }
        }
    }
}
