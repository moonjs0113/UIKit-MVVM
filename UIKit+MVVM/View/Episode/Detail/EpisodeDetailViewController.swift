//
//  EpisodeDetailViewController.swift
//  UIKit+MVVM
//
//  Created by Moon Jongseek on 2022/07/18.
//

import UIKit

class EpisodeDetailViewController: UIViewController {
    private var viewModel: EpisodeDetailViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    func setupUI() {
        view.backgroundColor = .white
        navigationItem.largeTitleDisplayMode = .always
        navigationController?.navigationBar.prefersLargeTitles = true
        title = "\(viewModel.episode.name)"
    }
    
    func prepareView(viewModel: EpisodeDetailViewModel) {
        self.viewModel = viewModel
    }
    
    func characterUI() {
        
    }
}
