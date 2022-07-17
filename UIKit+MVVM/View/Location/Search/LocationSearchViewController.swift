//
//  LocationSearchViewController.swift
//  UIKit+MVVM
//
//  Created by Moon Jongseek on 2022/07/17.
//

import UIKit

class LocationSearchViewController: UIViewController {
    @IBOutlet weak var totalCountLabel: UILabel!
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    
    // ID
    @IBOutlet weak var idStackView: UIStackView!
    @IBOutlet weak var idTextField: UITextField!
    
    @IBOutlet weak var requestButton: UIButton!
    
    @IBAction func editingChangedTextField(_ sender: UITextField) {
        requestButton.isEnabled = viewModel.isVaildateInputID(sender.text ?? "")
    }
    
    @IBAction func requestCharactersData(_ sender: UIButton) {
        startIndicatingActivity()
        if segmentedControl.selectedSegmentIndex == 0 {
            let ids = viewModel.convertStringToIntArray(idTextField.text ?? "")
            viewModel.requestMultipleInfo(ids: ids) { locations, error in
                DispatchQueue.main.async { [weak self] in
                    guard let locations = locations, error == nil else {
                        if let error = error {
                            self?.showAlertController(title: "에러", message: "Error: \(error.localizedDescription)") {
                                self?.stopIndicatingActivity()
                            }
                        }
                        return
                    }
                    self?.stopIndicatingActivity()
                    self?.navigateToResultView(locations)
                }
            }
        } else {
            stopIndicatingActivity()
        }
    }
    
    private var viewModel: SearchViewModel = SearchViewModel<Location>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.navigationBar.prefersLargeTitles = false
    }
    
    func setupUI() {
        idTextField.delegate = self
        
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
    
    private func navigateToResultView(_ locations: [Location]) {
        let controller = ResultViewController<Location>()
        let locationResultViewModel = viewModel.getResultViewModel(model: locations)
        controller.prepareView(viewModel: locationResultViewModel)
        navigationController?.pushViewController(controller, animated: true)
    }
}

extension LocationSearchViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        view.endEditing(true)
    }
}
