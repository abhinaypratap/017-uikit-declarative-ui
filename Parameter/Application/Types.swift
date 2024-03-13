//
//  Application.swift
//  Parameter
//
//  Created by Abhinay Pratap on 12/03/24.
//

import Foundation

struct Application: Decodable {
    let screens: [Screen]
}

struct Screen: Decodable {
    let id: String
    let title: String
    let type: String
    let rows: [Row]
    let rightButton: Button?
}

protocol HasAction {}

extension HasAction {
    func decodeAction(from container: KeyedDecodingContainer<ActionCodingKeys>) throws -> Action? {
        if let actionType = try container.decodeIfPresent(String.self, forKey: .actionType) {
            switch actionType {
            case "alert":
                return try container.decode(AlertAction.self, forKey: .action)
            case "showWebsite":
                return try container.decode(ShowWebsiteAction.self, forKey: .action)
            case "showScreen":
                return try container.decode(ShowScreenAction.self, forKey: .action)
            case "share":
                return try container.decode(ShareAction.self, forKey: .action)
            case "playMovie":
                return try container.decode(PlayMovieAction.self, forKey: .action)
            default:
                fatalError("Unknown action type: \(actionType)")
            }
        } else {
            return nil
        }
    }
}

enum ActionCodingKeys: String, CodingKey {
    case title
    case actionType
    case action
}

struct Row: Decodable, HasAction {

    let title: String
    var action: Action?

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: ActionCodingKeys.self)
        title = try container.decode(String.self, forKey: .title)
        action = try decodeAction(from: container)
    }
}

struct Button: Decodable, HasAction {
    var title: String
    var action: Action?

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: ActionCodingKeys.self)
        title = try container.decode(String.self, forKey: .title)
        action = try decodeAction(from: container)
    }
}

protocol Action: Decodable {
    var presentsNewScreen: Bool { get }
}

struct AlertAction: Action {
    let title: String
    let message: String

    var presentsNewScreen: Bool { false }
}

struct ShowWebsiteAction: Action {
    let url: URL

    var presentsNewScreen: Bool { true }
}

struct ShowScreenAction: Action {
    let id: String

    var presentsNewScreen: Bool { true }
}

struct ShareAction: Action {
    let text: String?
    let url: URL?

    var presentsNewScreen: Bool { false }
}

struct PlayMovieAction: Action {
    let url: URL

    var presentsNewScreen: Bool { true }
}
