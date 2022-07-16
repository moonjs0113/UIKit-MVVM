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
    }
    
    func prepareView(viewModel: ResultViewModel<Character>) {
        self.viewModel = viewModel
    }
    
    func setupUI() {
        view.backgroundColor = .white
        
    }
}
