//
//  TableScreen.swift
//  Parameter
//
//  Created by Abhinay Pratap on 12/03/24.
//

import UIKit

final class TableScreen: UITableViewController {

    var screen: Screen
    var navigationManager: NavigationManager?
    var reuseIdentifier = "reuse-id"

    init(screen: Screen) {
        self.screen = screen
        super.init(style: .insetGrouped)
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: reuseIdentifier)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        title = screen.title
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        screen.rows.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let row = screen.rows[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath)
        var content = cell.defaultContentConfiguration()
        content.text = row.title
        cell.contentConfiguration = content

        if let action = row.action {

            cell.selectionStyle = .default

            if action.presentsNewScreen {
                cell.accessoryType = .disclosureIndicator
            } else {
                cell.accessoryType = .none
            }
        } else {
            cell.selectionStyle = .none
        }

        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let row = screen.rows[indexPath.row]

        navigationManager?.execute(row.action, from: self)
        if row.action?.presentsNewScreen == false {
            tableView.deselectRow(at: indexPath, animated: true)
        }
    }

    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
}
