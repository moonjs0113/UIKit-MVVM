//
//  LocationDetailViewController.swift
//  UIKit+MVVM
//
//  Created by Moon Jongseek on 2022/07/18.
//

import UIKit

class LocationDetailViewController: UIViewController {
    private var locationDetailView = LocationDetailView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        startIndicatingActivity()
        title = locationDetailView.getTitleText()
        navigationItem.largeTitleDisplayMode = .always
        navigationController?.navigationBar.prefersLargeTitles = true
        locationDetailView.fetchData()
        stopIndicatingActivity()
    }
    
    override func loadView() {
        self.view = locationDetailView
        
        locationDetailView.residentsButton.addTarget(self, action: #selector(goToCharacterList(_:)), for: .touchUpInside)
    }
    
    func prepareView(viewModel: LocationDetailViewModel) {
        locationDetailView.prepareView(viewModel: viewModel)
    }
    
    @objc func goToCharacterList(_ sender: UIButton) {
        startIndicatingActivity()
        locationDetailView.goToCharacterList { [weak self] characters, error in
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
