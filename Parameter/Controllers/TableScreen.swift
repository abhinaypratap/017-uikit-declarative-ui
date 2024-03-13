//
//  TableScreen.swift
//  Parameter
//
//  Created by Abhinay Pratap on 12/03/24.
//

import SafariServices
import UIKit

final class TableScreen: UITableViewController {

    var screen: Screen
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
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let row = screen.rows[indexPath.row]

        if let action = row.action as? AlertAction {
            let vc = UIAlertController(title: action.title, message: action.message, preferredStyle: .alert)
            vc.addAction(UIAlertAction(title: "OK", style: .default))
            present(vc, animated: true)
        } else if let action = row.action as? ShowWebsiteAction {
            let vc = SFSafariViewController(url: action.url)
            navigationController?.present(vc, animated: true)
        }
    }

    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
}
