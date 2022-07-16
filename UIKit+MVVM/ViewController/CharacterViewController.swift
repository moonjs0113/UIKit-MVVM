//
//  CharacterViewController.swift
//  UIKit+MVVM
//
//  Created by Moon Jongseek on 2022/07/16.
//

import UIKit

class CharacterViewController: UIViewController {
    @IBOutlet weak var totalCountLabel: UILabel!
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    
    // ID
    @IBOutlet weak var idStackView: UIStackView!
    @IBOutlet weak var idTextField: UITextField!
    
    // Filter
    @IBOutlet weak var filterStackView: UIStackView!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var statusSegmentedControl: UISegmentedControl!
    @IBOutlet weak var speciesTextField: UITextField!
    @IBOutlet weak var typeTextField: UITextField!
    @IBOutlet weak var genderSegmentedControl: UISegmentedControl!

    
    @IBAction func changedSegControl(_ sender: UISegmentedControl) {
        idStackView.isHidden = !(sender.selectedSegmentIndex == 0)
        filterStackView.isHidden = (sender.selectedSegmentIndex == 0)
    }
    
    
    
    @IBAction func clearStatusValue(_ sender: UIButton) {
        statusSegmentedControl.selectedSegmentIndex = -1
    }
    
    @IBAction func clearGenderValue(_ sender: UIButton) {
        genderSegmentedControl.selectedSegmentIndex = -1
    }
    
    @IBAction func requestCharactersData(_ sender: UIButton) {
        startIndicatingActivity()
        if segmentedControl.selectedSegmentIndex == 0 {
            viewModel.requestMultipleInfo()
        }
    }
    
    
    
    
    private var viewModel: ViewModel = ViewModel<Character>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    func setupUI() {
        startIndicatingActivity()
        viewModel.requestTotalCount { count, error in
            DispatchQueue.main.async { [weak self] in
                guard let count = count, error == nil else {
                    if let error = error {
                        self?.showAlertController(title: "에러", message: "Error: \(error.localizedDescription)") {
                            self?.stopIndicatingActivity()
                        }
                    }
                    return
                }
                self?.totalCountLabel.text = "Total Count: \(count)"
                self?.stopIndicatingActivity()
            }
        }
    }
}
