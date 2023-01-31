import Foundation

enum DataManagerError: Error {
    case downloadingDataError
}

protocol DataManagering {
    func get(key: String) -> Data?
    func set(key: String, value: Data)
    func fetchData(url: URL, completion: @escaping (Result<Data, DataManagerError>) -> Void)
}

final class DataManager: DataManagering {
    private let cache = NSCache<NSString, NSData>()
    private let apiManager = ApiManager(networkManager: NetworkManager(session: URLSession.shared))
    private let queue = DispatchQueue.global(qos: .background)
    
    static let shared = DataManager()
    
    private init() {}
    
    func get(key: String) -> Data? {
        queue.sync {
            cache.object(forKey: key as NSString) as? Data
        }
    }

    func set(key: String, value: Data) {
        queue.sync {
            cache.setObject(value as NSData, forKey: key as NSString)
        }
    }
    
    func fetchData(url: URL, completion: @escaping (Result<Data, DataManagerError>) -> Void) {
        let stringURL = url.path
        if let data = get(key: stringURL) {
            completion(.success(data))
        } else {
            apiManager.downloadData(from: url) { [weak self] result in
                guard let self = self else { return }
                switch result {
                case .success(let data):
                    self.set(key: stringURL, value: data)
                    completion(.success(data))
                case .failure(_):
                    completion(.failure(.downloadingDataError))
                }
            }
        }
    }
}
