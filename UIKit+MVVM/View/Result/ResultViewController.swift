//
//  ResultViewController.swift
//  UIKit+MVVM
//
//  Created by Moon Jongseek on 2022/07/16.
//

import UIKit

class ResultViewController<M: Codable & Model>: UIViewController, UITableViewDelegate, UITableViewDataSource {
    private var viewModel: ResultViewModel<M>!
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupTableView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        navigationController?.navigationBar.prefersLargeTitles = false
    }
    
    // MARK: - Method
    func prepareView(viewModel: ResultViewModel<M>) {
        self.viewModel = viewModel
    }
    
    private func setupTableView() {
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
    
    private func setupUI() {
        view.backgroundColor = .white
        navigationItem.largeTitleDisplayMode = .never
        title = "Result"
    }
    
    // MARK: - Route
    private func setRoute(model: M) {
        if let character = model as? Character {
            navigateToCharacterDetailView(character)
        } else if let location = model as? Location {
            navigateToLocationDetailView(location)
        } else if let episode = model as? Episode {
            navigateToEpisodeDetailView(episode)
        } else {
            showAlertController(title: "에러", message: "Error: \(NetworkError.invalidType)")
        }
        stopIndicatingActivity()
    }
    
    private func navigateToCharacterDetailView(_ character: Character) {
        let controller = CharacterDetailViewController()
        let detailViewModel = viewModel.getCharacterViewModel(character: character)
        controller.prepareView(viewModel: detailViewModel)
        navigationController?.pushViewController(controller, animated: true)
    }
    
    private func navigateToLocationDetailView(_ location: Location) {
        let controller = LocationDetailViewController()
        let detailViewModel = viewModel.getLocationViewModel(location: location)
        controller.prepareView(viewModel: detailViewModel)
        navigationController?.pushViewController(controller, animated: true)
    }
    
    private func navigateToEpisodeDetailView(_ episode: Episode) {
        let controller = EpisodeDetailViewController()
        let detailViewModel = viewModel.getEpisodeViewModel(episode: episode)
        controller.prepareView(viewModel: detailViewModel)
        navigationController?.pushViewController(controller, animated: true)
    }
    
    // MARK: - Delegate
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
        startIndicatingActivity()
        viewModel.requestInfo(index: indexPath.row) { model, error in
            DispatchQueue.main.async { [weak self] in
                guard let model = model, error == nil else {
                    if let error = error {
                        self?.showAlertController(title: "에러", message: "Error: \(error.localizedDescription)") {
                            self?.stopIndicatingActivity()
                        }
                    }
                    return
                }
                self?.setRoute(model: model)
            }
        }
    }
}
