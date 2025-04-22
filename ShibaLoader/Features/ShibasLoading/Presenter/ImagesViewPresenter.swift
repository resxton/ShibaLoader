import Foundation

class ImagesViewPresenter: ImagesViewOutput {
    
    // MARK: - Public Properties
    
    weak var view: ImagesViewInput?
    
    // MARK: - Private Properties
    
    private let networkService: NetworkServiceProtocol
    
    // MARK: - Initializers
    
    init(networkService: NetworkServiceProtocol) {
        self.networkService = networkService
    }
    
    // MARK: - Public Methods
    
    func viewDidLoad() {}
    
    func didTapLoadImagesButton() {
        loadImages()
    }
    
    // MARK: - Private Methods
    
    private func loadImages() {
        view?.setLoaderVisible(true)
        
        let group = DispatchGroup()
        var dataArray: [Data] = []
        
        for url in Consts.urls {
            group.enter()
            networkService.download(from: url) { result in
                defer {
                    group.leave()
                }
                
                switch result {
                case .success(let data):
                    dataArray.append(data)
                case .failure(let error):
                    print(Consts.errorMessage, error.localizedDescription)
                }
            }
        }
        
        group.notify(queue: .main) { [weak self] in
            guard let self,
                  let view else { return }
            
            view.setLoaderVisible(false)
            view.disableLoadImagesButton()
            view.setImages(from: dataArray)
        }
    }
}

extension ImagesViewPresenter {
    private enum Consts {
        static let urls: [String] = [
            "https://i.pinimg.com/736x/37/56/df/3756df662821e4e70335d65c0a38bcc3.jpg",
            "https://i.pinimg.com/736x/c1/d0/53/c1d05382785ea77a8fa0e4511665ed26.jpg",
            "https://i.pinimg.com/736x/cf/22/80/cf22809e688aa6f40dd8cd32f056f10e.jpg"
        ]
        
        static let errorMessage: String = "Download error "
    }
}
