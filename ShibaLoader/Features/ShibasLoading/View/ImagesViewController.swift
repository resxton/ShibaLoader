import UIKit
import SnapKit

class ImagesViewController: UIViewController {
    
    // MARK: - Visual Components
    
    private let verticalStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = Consts.verticalSpacing
        stack.distribution = .fill
        stack.alignment = .center
        
        guard let placeholderImage = UIImage(
            named: Consts.placeholderImageName
        ) else {
            fatalError(Consts.placeholderErrorMessage)
        }
        
        for _ in 0..<Consts.imageCount {
            let imageView = UIImageView(image: placeholderImage)
            imageView.contentMode = .scaleAspectFit
            imageView.backgroundColor = Consts.imageBackgroundColor
            imageView.layer.cornerRadius = Consts.cornerRadius
            imageView.clipsToBounds = true
            
            stack.addArrangedSubview(imageView)
        }
        
        return stack
    }()
    
    private let loadImagesButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setTitle(Consts.loadImagesButtonTitle, for: .normal)
        button.backgroundColor = .accent
        button
            .setTitleColor(
                .customBlack.withAlphaComponent(
                    Consts.disabledStateAlpha
                ),
                for: .disabled
            )
        button.setTitleColor(.customBlack, for: .normal)
        if let titleLabel = button.titleLabel {
            titleLabel.font = UIFont(
                name: Consts.fontName,
                size: Consts.loadImagesButtonTitleFontSize
            )
        }
        button.layer.cornerRadius = Consts.cornerRadius
        button.layer.masksToBounds = true
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
    }
    
    // MARK: - Private Methods
    
    private func setupUI() {
        view.backgroundColor = .systemBackground
        view.addSubview(verticalStack)
        view.addSubview(loadImagesButton)
        view.addSubview(loader)
    }
    
    private func setupConstraints() {
        loadImagesButton.snp.makeConstraints { make in
            make.leading.trailing.bottom.equalTo(view.layoutMarginsGuide)
            make.height.equalTo(Consts.loadImagesButtonHeight)
        }

        verticalStack.snp.makeConstraints { make in
            make.leading.trailing.top.equalTo(view.layoutMarginsGuide)
            make.bottom.equalTo(loadImagesButton.snp.top).offset(-Consts.verticalSpacing)
        }

        loader.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

        for (index, view) in verticalStack.arrangedSubviews.enumerated() {
            view.snp.makeConstraints { make in
                /// Делаем картинки квадратными
                make.width.equalTo(view.snp.height)
                
                if index == 0 {
                    make.height
                        .lessThanOrEqualTo(verticalStack.snp.height)
                    /// Высота первой картинки — 1 / n высоты stackView, где n – число картинок
                        .multipliedBy(1.0 / CGFloat(Consts.imageCount))
                    /// с учетом вертикальных отступов (на 1 меньше, чем картинок)
                        .offset(
                            -CGFloat((Consts.imageCount - 1)) * Consts.verticalSpacing / CGFloat(Consts.imageCount)
                        )
                } else {
                    /// Высоты картинок равны
                    make.height
                        .equalTo(
                            verticalStack.arrangedSubviews[0].snp.height
                        )
                }
            }
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
        if isVisible {
            UIView.animate(withDuration: Consts.animationDuration) {
                self.loader.alpha = 1
                self.loader.startAnimating()
            }
        } else {
            UIView.animate(withDuration: Consts.animationDuration, animations: {
                self.loader.alpha = 0
            }, completion: { _ in
                self.loader.stopAnimating()
            })
        }
    }
    
    func presentAlert(title: String, message: String?) {
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
    
    func setImages(from dataArray: [Data]) {
        guard dataArray.count == Consts.imageCount else { return }
        
        for (index, arrangedSubview) in verticalStack.arrangedSubviews.enumerated() {
            let image = UIImage(data: dataArray[index])
            if let imageSubview = arrangedSubview as? UIImageView {
                imageSubview.image = image
            }
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
        static let fontName: String = "TinkoffSans-Medium"

        static let imageBackgroundColor: UIColor = .white
        static let animationDuration: TimeInterval = 0.3
        
        static let verticalSpacing: CGFloat = 16
        static let loadImagesButtonHeight: CGFloat = 50
        static let cornerRadius: CGFloat = 16
        static let loadImagesButtonTitleFontSize: CGFloat = 24
        static let disabledStateAlpha: CGFloat = 0.5
        
        static let imageCount: Int = 3
    }
}
