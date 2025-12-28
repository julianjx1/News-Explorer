//
//  ImageCacheManager.swift
//  News Explorer
//
//  Created by Mahir Shahriar Lipeng on 28/12/25.
//

import UIKit

final class ImageCacheManager {
    
    static let shared = ImageCacheManager()
    
    private let cache = NSCache<NSString, UIImage>()
    private let session = URLSession.shared
    
    private init() {}
    
    
    func getImage(for key: String) -> UIImage? {
        return cache.object(forKey: key as NSString)
    }
    
    func cacheImage(_ image: UIImage, for key: String) {
        cache.setObject(image, forKey: key as NSString)
    }
    
    
    func downloadImage(from urlString: String, completion: @escaping (UIImage?) -> Void) {
        
        guard let url = URL(string: urlString) else {
            completion(nil)
            return
        }
        
        if let cachedImage = getImage(for: urlString) {
            completion(cachedImage)
            return
        }
        
        session.dataTask(with: url) { [weak self] data, response, error in
            guard let self = self,
                  let data = data,
                  let image = UIImage(data: data),
                  error == nil else {
                DispatchQueue.main.async { completion(nil) }
                return
            }
            
            self.cacheImage(image, for: urlString)
            
            DispatchQueue.main.async {
                completion(image)
            }
        }.resume()
    }
}
