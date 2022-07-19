//
//  CharacterDetailViewController.swift
//  UIKit+MVVM
//
//  Created by Moon Jongseek on 2022/07/17.
//

import UIKit
import Combine

class CharacterDetailViewController: UIViewController {
    private var characterDetailView = CharacterDetailView()
    private var subscriptions = Set<AnyCancellable>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        startIndicatingActivity()
        title = characterDetailView.getTitleText()
        navigationItem.largeTitleDisplayMode = .always
        navigationController?.navigationBar.prefersLargeTitles = true
        characterDetailView.setupUI()
        stopIndicatingActivity()
    }
    
    override func loadView() {
        self.view = characterDetailView
        
        characterDetailView.originLocationButton.addTarget(self, action: #selector(goToLocationDetail(_:)), for: .touchUpInside)
        
        characterDetailView.locationButton.addTarget(self, action: #selector(goToLocationDetail(_:)), for: .touchUpInside)
        
        characterDetailView.episodeButton.addTarget(self, action: #selector(goToEpisodeList(_:)), for: .touchUpInside)
        
        characterDetailView.$error.compactMap { $0 }
        .sink { [weak self] error in
            self?.showAlertController(title: "에러",
                                      message: "Error: \(error)")
            self?.characterDetailView.clearError()
        }
        .store(in: &subscriptions)
    }
    
    func prepareView(viewModel: CharacterDetailViewModel) {
        characterDetailView.prepareView(viewModel: viewModel)
    }
    
    @objc func goToLocationDetail(_ sender: UIButton) {
        startIndicatingActivity()
        Task {
            if let location = await characterDetailView.requestLocationData(tag: sender.tag) {
                let locationViewModel = LocationDetailViewModel(location: location)
                self.navigateToLocationDetailView(locationViewModel)
            }
            self.stopIndicatingActivity()
        }
    }
    
    @objc func goToEpisodeList(_ sender: UIButton) {
        startIndicatingActivity()
        characterDetailView.goToEpisodeList { [weak self] episodes in
            if let episodes = episodes {
                let resultViewModel = ResultViewModel<Episode>(models: episodes)
                self?.navigateToEpisodeListView(resultViewModel)
            }
            self?.stopIndicatingActivity()
        }
    }
    
    private func navigateToLocationDetailView(_ viewModel: LocationDetailViewModel) {
        let controller = LocationDetailViewController()
        controller.prepareView(viewModel: viewModel)
        navigationController?.pushViewController(controller, animated: true)
    }
    
    private func navigateToEpisodeListView(_ viewModel: ResultViewModel<Episode>) {
        let controller = ResultViewController<Episode>()
        controller.prepareView(viewModel: viewModel)
        navigationController?.pushViewController(controller, animated: true)
    }
}
