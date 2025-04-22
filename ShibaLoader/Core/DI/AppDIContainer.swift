import Foundation

final class AppDIContainer {
    
    // MARK: - Private Properties
    
    private lazy var networkService: NetworkServiceProtocol = NetworkService()
    
    // MARK: - Public Methods
    
    public func makeImagesViewController() -> ImagesViewController {
        let networkService = NetworkService()
        let presenter = ImagesViewPresenter(networkService: networkService)
        let view = ImagesViewController(presenter: presenter)
        presenter.view = view
        
        return view
    }
}
