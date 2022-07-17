//
//  CharacterDetailViewController.swift
//  UIKit+MVVM
//
//  Created by Moon Jongseek on 2022/07/17.
//

import UIKit

class CharacterDetailViewController: UIViewController {
    private var viewModel: CharacterDetailViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    func setupUI() {
        view.backgroundColor = .white
        navigationItem.largeTitleDisplayMode = .always
        navigationController?.navigationBar.prefersLargeTitles = true
        title = "\(viewModel.character.name)"
        
    }
    
    func prepareView(viewModel: CharacterDetailViewModel) {
        self.viewModel = viewModel
    }
    
    func characterUI() {
        
    }
}
