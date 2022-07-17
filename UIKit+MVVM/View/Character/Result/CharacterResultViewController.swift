//
//  CharacterResultViewController.swift
//  UIKit+MVVM
//
//  Created by Moon Jongseek on 2022/07/16.
//

import UIKit

class CharacterResultViewController: UIViewController {
    private var viewModel: ResultViewModel<Character>!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupTableView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        navigationController?.navigationBar.prefersLargeTitles = false
    }
    
    func prepareView(viewModel: ResultViewModel<Character>) {
        self.viewModel = viewModel
    }
    
    func setupTableView() {
        let tableView = UITableView(frame: .zero, style: .insetGrouped)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(tableView)
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: self.view.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
        ])
    }
    
    func setupUI() {
        view.backgroundColor = .white
        navigationItem.largeTitleDisplayMode = .never
        title = "Result"
    }
    
    private func navigateToCharacterDetailView(_ character: Character) {
        let controller = CharacterDetailViewController()
        let characterDetailViewModel = viewModel.getCharacterViewModel(model: character)
        controller.prepareView(viewModel: characterDetailViewModel)
        navigationController?.pushViewController(controller, animated: true)
    }
}

extension CharacterResultViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.models.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: nil)
        cell.textLabel?.text = viewModel.models[indexPath.row].name
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        navigateToCharacterDetailView(viewModel.models[indexPath.row])
    }
}
