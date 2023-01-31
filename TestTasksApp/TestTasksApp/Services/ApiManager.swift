import Foundation

enum ApiError: Error {
    case requestFailed
    case responseError
    case dataParsingError
    case urlParsingError
    case noData
}


protocol ApiManagering {
    func makeRequest(page: Int, count: Int, completion: @escaping (Result<[PhotoModel], ApiError>) -> Void)
    func downloadData(from url: URL, completion: @escaping (Result<Data, ApiError>) -> Void)
}

final class ApiManager: ApiManagering {
    private let networkManager: NetworkManagering
    private let page: Int
    private let count: Int
    
    init(networkManager: NetworkManagering, page: Int = 1, count: Int = 20) {
        self.networkManager = networkManager
        self.page = page
        self.count = count
    }
    
    func makeRequest(page: Int, count: Int, completion: @escaping (Result<[PhotoModel], ApiError>) -> Void) {
        let stringURL = "https://api.unsplash.com/photos/?client_id=v6gYNEmZzZCBVu_aVTGmHNQduCmZwUdqjQzM_IViH7Q&page=\(page)&per_page=\(count)"
        guard let url = URL(string: stringURL) else { return }
        
        let request = URLRequest(url: url)
        
        networkManager.makeRequest(urlRequest: request) { result in
            let result: Result<[PhotoModel], NetworkError> = result
            
            switch result {
            case .success(let success):
                completion(.success(success))
            case .failure(_):
                completion(.failure(.responseError))
            }
        }
        
    }
    
    func downloadData(from url: URL, completion: @escaping (Result<Data, ApiError>) -> Void) {
        networkManager.getData(from: url) { [weak self] result in
            switch result {
            case .success(let success):
                completion(.success(success))
            case .failure(_):
                completion(.failure(.responseError))
            }
        }
    }
}
