//
//  CharacterSearchViewController.swift
//  UIKit+MVVM
//
//  Created by Moon Jongseek on 2022/07/16.
//

import UIKit

class CharacterSearchViewController: UIViewController {
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
    
    @IBOutlet weak var requestButton: UIButton!
    
    @IBAction func changedSegControl(_ sender: UISegmentedControl) {
        idStackView.isHidden = !(sender.selectedSegmentIndex == 0)
        filterStackView.isHidden = (sender.selectedSegmentIndex == 0)
    }
    
    @IBAction func editingChangedTextField(_ sender: UITextField) {
        requestButton.isEnabled = viewModel.isVaildateInputID(sender.text ?? "")
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
            let ids = viewModel.convertStringToIntArray(idTextField.text ?? "")
            viewModel.requestMultipleInfo(ids: ids) {[weak self] in
                self?.fetchData()
                self?.stopIndicatingActivity()
            }
        }
    }
    
    private var viewModel: SearchViewModel = SearchViewModel<Character>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.navigationBar.prefersLargeTitles = false
    }
    
    func setupUI() {
        idTextField.delegate = self
        nameTextField.delegate = self
        speciesTextField.delegate = self
        typeTextField.delegate = self
        
        startIndicatingActivity()
        viewModel.requestTotalCount { [weak self] in
            self?.fetchData()
            self?.stopIndicatingActivity()
        }
    }
    
    func fetchData() {
        if let error = viewModel.error {
            showAlertController(title: "에러",
                                message: "Error: \(error.localizedDescription)") { [weak self] in
                self?.viewModel.clearError()
            }
        }
        totalCountLabel.text = "Total Count: \(viewModel.totalCount)"
        if let models = viewModel.models {
            viewModel.models = nil
            navigateToResultView(models)
        }
    }
    
    private func navigateToResultView(_ characters: [Character]) {
        let controller = ResultViewController<Character>()
        let characterResultViewModel = viewModel.getResultViewModel(model: characters)
        controller.prepareView(viewModel: characterResultViewModel)
        navigationController?.pushViewController(controller, animated: true)
    }
}

extension CharacterSearchViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        view.endEditing(true)
    }
}
