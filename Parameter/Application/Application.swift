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
}

struct Row: Decodable {

    enum ActionCodingKeys: String, CodingKey {
        case title
        case actionType
        case action
    }

    let title: String
    let action: Action?

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: ActionCodingKeys.self)
        title = try container.decode(String.self, forKey: .title)
        if let actionType = try container.decodeIfPresent(String.self, forKey: .actionType) {
            switch actionType {
            case "alert":
                action = try container.decode(AlertAction.self, forKey: .action)
            case "showWebsite":
                action = try container.decode(ShowWebsiteAction.self, forKey: .action)
            default:
                fatalError("Unknown action type: \(actionType)")
            }
        } else {
            action = nil
        }
    }
}

protocol Action: Decodable { }

struct AlertAction: Action {
    let title: String
    let message: String
}

struct ShowWebsiteAction: Action {
    let url: URL
}
