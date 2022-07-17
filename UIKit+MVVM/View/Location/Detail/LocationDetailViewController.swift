//
//  LocationDetailViewController.swift
//  UIKit+MVVM
//
//  Created by Moon Jongseek on 2022/07/18.
//

import UIKit

class LocationDetailViewController: UIViewController {
    private var viewModel: LocationDetailViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    func setupUI() {
        view.backgroundColor = .white
        navigationItem.largeTitleDisplayMode = .always
        navigationController?.navigationBar.prefersLargeTitles = true
        title = "\(viewModel.location.name)"
        
    }
    
    func prepareView(viewModel: LocationDetailViewModel) {
        self.viewModel = viewModel
    }
    
    func characterUI() {
        
    }
}
