//
//  CharacterDetailView.swift
//  UIKit+MVVM
//
//  Created by Moon Jongseek on 2022/07/18.
//

import UIKit
import Combine

class CharacterDetailView: UIView {
    private var viewModel: CharacterDetailViewModel!
    private var subscriptions = Set<AnyCancellable>()
    @Published private(set)var error: NetworkError?
    
    // MARK: - Interface Builder
    @IBOutlet var view: UIView!
    
    @IBOutlet weak var idLabel: UILabel!
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var imageViewIndicator: UIActivityIndicatorView!
    
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var speciesLabel: UILabel!
    @IBOutlet weak var genderLabel: UILabel!
    
    @IBOutlet weak var originLocationButton: UIButton!
    @IBOutlet weak var locationButton: UIButton!
    
    @IBOutlet weak var episodeButton: UIButton!
    
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
        
        viewModel.requestImageData()
    }
    
    // MARK: - Method
    func prepareView(viewModel: CharacterDetailViewModel) {
        self.viewModel = viewModel
    }
    
    func getTitleText() -> String {
        return viewModel.character.name
    }
    
    func setupUI() {
        viewModel.$imageData.map { optionalData in
            guard let data = optionalData else {
                return nil
            }
            DispatchQueue.main.async { [weak self] in
                self?.imageViewIndicator.stopAnimating()
            }
            return UIImage(data: data)
        }
        .assign(to: \.image, on: imageView)
        .store(in: &subscriptions)
        
        viewModel.$error.compactMap { $0 }
            .sink { [weak self] error in
                self?.error = error
                self?.viewModel.clearError()
            }
            .store(in: &subscriptions)
        
        fetchData()
    }
    
    func requestLocationData(tag: Int) async -> Location? {
        let url = tag == 0 ? viewModel.character.origin.url : viewModel.character.location.url
        do {
            return try await viewModel.requestLocationData(url: url)
        } catch (let error) {
            self.error = error as? NetworkError
            return nil
        }
    }
    
    func goToEpisodeList(completeHandler: @escaping ([Episode]?) -> ()) {
        viewModel.requestEpisodeList { episodes, error in
            self.error = error
            DispatchQueue.main.async {
                completeHandler(episodes)
            }
        }
    }
    
    func clearError() {
        error = nil
    }
}
