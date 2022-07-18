//
//  LocationDetailView.swift
//  UIKit+MVVM
//
//  Created by Moon Jongseek on 2022/07/18.
//

import UIKit

class LocationDetailView: UIView {
    private var viewModel: LocationDetailViewModel!
    
    // MARK: - Interface Builder
    @IBOutlet var view: UIView!
    
    @IBOutlet weak var idLabel: UILabel!
    
    @IBOutlet weak var typeLabel: UILabel!
    @IBOutlet weak var dimensionLabel: UILabel!
    
    @IBOutlet weak var residentsButton: UIButton!
    
    // MARK: - Life Cycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    // MARK: - Private Method
    private func commonInit() {
        Bundle.main.loadNibNamed("LocationDetailView", owner: self, options: .none)
        addSubview(view)
        view.frame = self.bounds
        view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
    }
    
    func fetchData() {
        idLabel.text = "ID: \(viewModel.location.id)"
        typeLabel.text = viewModel.location.type
        dimensionLabel.text = viewModel.location.dimension
    }
    
    func prepareView(viewModel: LocationDetailViewModel) {
        self.viewModel = viewModel
    }
    
    func getTitleText() -> String {
        return viewModel.location.name
    }
    
    func goToCharacterList(completeHandler: @escaping NetworkClosure<[Character]>) {
        viewModel.requestCharacterList { characters, error in
            DispatchQueue.main.async {
                completeHandler(characters, error)
            }
        }
    }
    
}
