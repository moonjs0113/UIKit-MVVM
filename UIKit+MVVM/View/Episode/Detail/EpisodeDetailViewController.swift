//
//  EpisodeDetailViewController.swift
//  UIKit+MVVM
//
//  Created by Moon Jongseek on 2022/07/18.
//

import UIKit

class EpisodeDetailViewController: UIViewController {
    private var episodeDetailView: EpisodeDetailView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        startIndicatingActivity()
        title = episodeDetailView.getTitleText()
        navigationItem.largeTitleDisplayMode = .always
        navigationController?.navigationBar.prefersLargeTitles = true
        episodeDetailView.fetchData()
        stopIndicatingActivity()
    }
    override func loadView() {
        self.view = episodeDetailView
        
        episodeDetailView.charactersButton.addTarget(self, action: #selector(goToCharacterList(_:)), for: .touchUpInside)
    }
    
    func prepareView(viewModel: EpisodeDetailViewModel) {
        episodeDetailView.prepareView(viewModel: viewModel)
    }
    
    @objc func goToCharacterList(_ sender: UIButton) {
        startIndicatingActivity()
        episodeDetailView.goToCharacterList { [weak self] characters, error in
            if let error = error {
                self?.showAlertController(title: "에러",
                                    message: "Error: \(error.localizedDescription)")
            } else if let characters = characters {
                let resultViewModel = ResultViewModel<Character>(models: characters)
                self?.navigateToCharacterListView(resultViewModel)
            }
            self?.stopIndicatingActivity()
        }
    }
    
    private func navigateToCharacterListView(_ viewModel: ResultViewModel<Character>) {
        let controller = ResultViewController<Character>()
        controller.prepareView(viewModel: viewModel)
        navigationController?.pushViewController(controller, animated: true)
    }
}
