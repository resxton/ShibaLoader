import Alamofire

class NetworkService: NetworkServiceProtocol {
    func download(
        from url: String,
        completion: @escaping (Result<Data, Error>) -> Void
    ) {
        AF.request(url)
            .validate()
            .responseData { response in
                switch response.result {
                case .success(let data):
                    completion(.success(data))
                case .failure(let error):
                    completion(.failure(error))
                }
            }
    }
}
