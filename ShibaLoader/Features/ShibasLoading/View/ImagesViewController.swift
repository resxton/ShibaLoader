import UIKit
import SnapKit

class ImagesViewController: UIViewController {
    
    // MARK: - Visual Components
    
    private let verticalStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.distribution = .equalSpacing
        stack.alignment = .center
        
        guard let placeholderImage = UIImage(
            named: Consts.placeholderImageName
        ) else {
            fatalError(Consts.placeholderErrorMessage)
        }
        
        for _ in 0..<3 {
            let imageView = UIImageView(image: placeholderImage)
            imageView.contentMode = .scaleAspectFit
            imageView.backgroundColor = Consts.imageBackgroundColor
            
            stack.addArrangedSubview(imageView)
        }
        
        return stack
    }()
    
    private let loadImagesButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setTitle(Consts.loadImagesButtonTitle, for: .normal)
        button.backgroundColor = .accent
        button.setTitleColor(.customBlack, for: .normal)
        button.addTarget(nil, action: #selector(didTapLoadImagesButton), for: .touchUpInside)
        return button
    }()
    
    private let loader: UIActivityIndicatorView = {
        let loader = UIActivityIndicatorView(style: .large)
        loader.backgroundColor = .accent
        loader.color = .customBlack
        loader.alpha = 0
        return loader
    }()
    
    // MARK: - Private Properties
    
    private let presenter: ImagesViewOutput
    
    // MARK: - Initializers
    
    init(presenter: ImagesViewOutput) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        setupConstraints()
        
        presenter.viewDidLoad()
    }
    
    // MARK: - Private Methods
    
    private func setupUI() {
        view.backgroundColor = .systemBackground
        view.addSubview(verticalStack)
        view.addSubview(loader)
    }
    
    private func setupConstraints() {
        loadImagesButton.snp.makeConstraints { make in
            make.leading.trailing.bottom.equalTo(view.layoutMarginsGuide)
            make.height.equalTo(Consts.loadImagesButtonTitleHeight)
        }
        
        verticalStack.snp.makeConstraints { make in
            make.leading.trailing.top.equalTo(view.layoutMarginsGuide)
            make.bottom.equalTo(loadImagesButton.snp.top)
        }
        
        loader.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    @objc
    private func didTapLoadImagesButton() {
        presenter.didTapLoadImagesButton()
    }
}

// MARK: - ImagesViewInput

extension ImagesViewController: ImagesViewInput {
    func setLoaderVisible(_ isVisible: Bool) {
        DispatchQueue.main.async { [weak self] in
            guard let self else { return }
            
            if isVisible {
                loader.startAnimating()
                loader.alpha = 1
            } else {
                UIView.animate(withDuration: Consts.animationDuration, animations: {
                    self.loader.alpha = 0
                }, completion: { _ in
                    self.loader.stopAnimating()
                })
            }
        }
    }
    
    func presentAlert(title: String, message: String?) {
        DispatchQueue.main.async { [weak self] in
            guard let self else { return }
            let alert = UIAlertController(
                title: title,
                message: message,
                preferredStyle: .alert
            )
            let action = UIAlertAction(
                title: Consts.actionTitle,
                style: .cancel
            )
            alert.addAction(action)
            present(alert, animated: true)
        }
    }
}

// MARK: - ImagesViewController.Consts

extension ImagesViewController {
    private enum Consts {
        static let placeholderImageName: String = "placeholder"
        static let placeholderErrorMessage: String = "No such image"
        static let actionTitle: String = "ОК"
        static let loadImagesButtonTitle: String = "Загрузить картинки"

        static let imageBackgroundColor: UIColor = .white
        static let animationDuration: TimeInterval = 0.3
        
        static let loadImagesButtonTitleHeight: CGFloat = 50
    }
}
