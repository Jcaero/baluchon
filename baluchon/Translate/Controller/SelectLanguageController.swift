//
//  SelectLanguage.swift
//  baluchon
//
//  Created by pierrick viret on 29/08/2023.
//

import UIKit

protocol SelectLanguageDelegate: AnyObject {
    func changeLanguageOutput( with language: String)
}

class SelectLanguageController: UIViewController {
    // MARK: - Delegate
    private weak var delegate: SelectLanguageDelegate?

    init(delegate: SelectLanguageDelegate?) {
        self.delegate = delegate
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Properties
    var tableView: UITableView!
    let language = Array(languageNames.keys).sorted()

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView = UITableView(frame: view.bounds, style: .plain)

        tableView.dataSource = self
        tableView.delegate = self

        view.backgroundColor = .white
        tableView.translatesAutoresizingMaskIntoConstraints = false

        view.addSubview(tableView)
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)])
    }
}

// MARK: - Extension TableView
extension SelectLanguageController: UITableViewDataSource, UITableViewDelegate {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return language.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        var config = cell.defaultContentConfiguration()
        config.text = language[indexPath.row]
        cell.contentConfiguration = config
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.delegate?.changeLanguageOutput(with: language[indexPath.row])
        dismiss(animated: true)
    }
}
