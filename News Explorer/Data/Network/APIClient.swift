//
//  APIClient.swift
//  News Explorer
//
//  Created by Mahir Shahriar Lipeng on 28/12/25.
//

import Foundation
import RxSwift
import RxCocoa

final class APIClient {
    
    static let shared = APIClient()
    private let session = URLSession.shared
    
    private init() {}
    
 
    func request<T: Decodable>(_ api: NewsAPI) -> Observable<T> {
        
        guard let url = api.url else {
            return Observable.error(NetworkError.invalidURL)
        }
        
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        
        return session.rx.data(request: URLRequest(url: url))
            .observe(on: ConcurrentDispatchQueueScheduler(qos: .default))
            .catch { error in
                throw NetworkError.network(error)
            }
            .map { data in
                do {
                    return try decoder.decode(T.self, from: data)
                } catch let decodingError {
                    throw NetworkError.decoding(decodingError)
                }
            }
            .asObservable()
    }
}
