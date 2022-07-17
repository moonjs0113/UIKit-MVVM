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
        title = "\(viewModel.model.name)"
        
    }
    
    func prepareView(viewModel: CharacterDetailViewModel) {
        self.viewModel = viewModel
    }
    
    func characterUI() {
        
//        let status: String
//        let species: String
//        let type: String
//        let gender: String
//
//        let origin: CharacterLocation
        
//        let location: CharacterLocation
//
//        let image: String
//
//        let url: String
//        let episode: [String]
//        let created: String
    }
}
