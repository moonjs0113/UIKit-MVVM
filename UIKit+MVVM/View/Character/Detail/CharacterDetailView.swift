//
//  CharacterDetailView.swift
//  UIKit+MVVM
//
//  Created by Moon Jongseek on 2022/07/18.
//

import UIKit

class CharacterDetailView: UIView {
    private var viewModel: CharacterDetailViewModel!
    
    // MARK: - Interface Builder
    @IBOutlet var view: UIView!
    
    @IBOutlet weak var idLabel: UILabel!
    
    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var speciesLabel: UILabel!
    @IBOutlet weak var genderLabel: UILabel!
    
    @IBOutlet weak var originLocationButton: UIButton!
    @IBOutlet weak var locationButton: UIButton!
    
    @IBOutlet weak var episdoeButton: UIButton!
    
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
        Bundle.main.loadNibNamed("CharacterDetailView", owner: self, options: .none)
        addSubview(view)
        view.frame = self.bounds
        view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        imageView.layer.cornerRadius = 10
    }
    
    private func fetchData() {
        idLabel.text = "ID: \(viewModel.character.id)"
        statusLabel.text = viewModel.character.status
        speciesLabel.text = viewModel.character.species
        if !viewModel.character.type.isEmpty, let text = speciesLabel.text {
            speciesLabel.text = text + viewModel.character.type
        }
        genderLabel.text = viewModel.character.gender

        originLocationButton.setTitle(viewModel.character.origin.name , for: .normal)
        if let title = originLocationButton.title(for: .normal), title == "unknown" {
            originLocationButton.isEnabled = false
        }
        
        locationButton.setTitle(viewModel.character.location.name , for: .normal)
        if let title = locationButton.title(for: .normal), title == "unknown" {
            locationButton.isEnabled = false
        }
        
        if let imageData = viewModel.imageData {
            imageView.image = UIImage(data: imageData, scale: 1)
        }
    }
    
    // MARK: - Method
    func prepareView(viewModel: CharacterDetailViewModel) {
        self.viewModel = viewModel
    }
    
    func getTitleText() -> String {
        return viewModel.character.name
    }
    
    func setupUI(completeHandler: @escaping (NetworkError?) -> ()) {
        viewModel.requestImageData { [weak self] in
            self?.fetchData()
            completeHandler(self?.viewModel.error)
            self?.viewModel.clearError()
        }
    }
    
    func goToLocationDetail(tag: Int, completeHandler: @escaping NetworkClosure<Location>) {
        let url = tag == 0 ? viewModel.character.origin.url : viewModel.character.location.url
        viewModel.requestLocationData(url: url) { location, error in
            DispatchQueue.main.async {
                completeHandler(location, error)
            }
        }
    }
    
    func goToEpisodeList(completeHandler: @escaping NetworkClosure<[Episode]>) {
        viewModel.requestEpisodeList { episodes, error in
            DispatchQueue.main.async {
                completeHandler(episodes, error)
            }
        }
    }
}
