import Foundation

enum NetworkError: Error {
    case requestError
    case responseError
    case recieveDataError
}
protocol NetworkManagering {
    func makeRequest<T: Codable> (urlRequest: URLRequest, completion: @escaping (Result<T, NetworkError>) -> Void)
    func getData(from url: URL, completion: @escaping (Result<Data, NetworkError>) -> ()) 
}

final class NetworkManager: NetworkManagering {
    private let session: URLSession
    
    init(session: URLSession) {
        self.session = session
    }
    func getData(from url: URL, completion: @escaping (Result<Data, NetworkError>) -> ()) {
        let request = URLRequest(url: url)
        getData(from: request, completion: completion)
    }
    
    private func getData(from urlRequest: URLRequest, completion: @escaping (Result<Data, NetworkError>) -> Void) {
        session.dataTask(with: urlRequest) { data, response, error in
            
            if error != nil {
                completion(.failure(.requestError))
                return
            }
                        
            guard let response = response,
                  let statusCode = (response as? HTTPURLResponse)?.statusCode,
                  (200 ... 299) ~= statusCode
            else {
                completion(.failure(.responseError))
                return
            }
            
            if let data = data {
                completion(.success(data))
            } else {
                completion(.failure(.recieveDataError))
                return
            }
        }.resume()
    }
    
    func makeRequest<T: Codable> (urlRequest: URLRequest, completion: @escaping (Result<T, NetworkError>) -> Void) {
        getData(from: urlRequest) { result in
            switch result {
            case .success(let data):
                do {
                    let result = try JSONDecoder().decode(T.self, from: data)
                    completion(.success(result))
                }
                catch {
                    completion(.failure(.requestError))
                }
            case .failure(let failure):
                completion(.failure(failure))
            }
        }
    }
}
