//
//  CharacterDetailViewController.swift
//  UIKit+MVVM
//
//  Created by Moon Jongseek on 2022/07/17.
//

import UIKit

class CharacterDetailViewController: UIViewController {
    var characterDetailView = CharacterDetailView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        startIndicatingActivity()
        title = characterDetailView.getTitleText()
        characterDetailView.setupUI { [weak self] error in
            if let error = error {
                self?.showAlertController(title: "에러",
                                    message: "Error: \(error.localizedDescription)")
            }
            self?.stopIndicatingActivity()
        }
    }
    
    override func loadView() {
        self.view = characterDetailView
        
        characterDetailView.originLocationButton.addTarget(self, action: #selector(goToLocationDetail(_:)), for: .touchUpInside)
        
        characterDetailView.locationButton.addTarget(self, action: #selector(goToLocationDetail(_:)), for: .touchUpInside)
        
        characterDetailView.episdoeButton.addTarget(self, action: #selector(goToEpisodeList(_:)), for: .touchUpInside)
    }
    
    func prepareView(viewModel: CharacterDetailViewModel) {
        characterDetailView.prepareView(viewModel: viewModel)
    }
    
    @objc func goToLocationDetail(_ sender: UIButton) {
        startIndicatingActivity()
        characterDetailView.goToLocationDetail(tag: sender.tag) { [weak self] location, error in
            if let error = error {
                self?.showAlertController(title: "에러",
                                    message: "Error: \(error.localizedDescription)")
            } else if let location = location {
                let locationViewModel = LocationDetailViewModel(location: location)
                self?.navigateToLocationDetailView(locationViewModel)
            }
            self?.stopIndicatingActivity()
        }
    }
    
    @objc func goToEpisodeList(_ sender: UIButton) {
        startIndicatingActivity()
        characterDetailView.goToEpisodeList { [weak self] episodes, error in
            if let error = error {
                self?.showAlertController(title: "에러",
                                    message: "Error: \(error.localizedDescription)")
            } else if let episodes = episodes {
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
