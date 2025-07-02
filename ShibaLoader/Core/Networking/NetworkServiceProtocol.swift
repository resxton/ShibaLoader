import Foundation

protocol NetworkServiceProtocol {
    func download(
        from url: String,
        completion: @escaping (Result<Data, Error>) -> Void
    )
}
