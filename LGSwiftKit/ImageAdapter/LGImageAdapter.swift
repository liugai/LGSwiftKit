//
//  LGImageAdapter.swift
//  LGSwiftKit
//
//  Created by 刘盖 on 2021/10/27.
//

import UIKit
import Kingfisher

public final class LGImageAdapter: NSObject {
    
    let shared: LGImageAdapter = LGImageAdapter()
    
    ///获取图片缓存key
    public class func imageKey(url: String) -> String? {
        guard let key = URL(string: url)?.cacheKey else {
            return nil
        }
        return key
    }
    
    ///获取图片缓存路径
    public class func imagePath(url: String) -> String? {
        guard let key = self.imageKey(url: url) else {
            return nil
        }
        return ImageCache.default.cachePath(forKey: key)
    }
    
    public class func imageForCache(url: String, options: LGImageAdapterOptionsInfo?, completionHandler: ((UIImage?, LGCacheType) -> Void)?) -> Void {
        if let key = self.imageKey(url: url) {
            ImageCache.default.retrieveImage(forKey: key, options: LGImageAdapter.convertOptionsToKingOptions(options: options), completionHandler:{ image, cacheType in
                if let completionHandler = completionHandler {
                    completionHandler(image, LGImageAdapter.cacheTypeFromKingCacheType(cacheType: cacheType))
                    return
                }
            })
            return
        }
        if let completionHandler = completionHandler {
            completionHandler(nil, LGCacheType.none)
        }
    }
    
}

extension LGImageAdapter {
     class func convertOptionsToKingOptions(options: LGImageAdapterOptionsInfo?) -> KingfisherOptionsInfo? {
        var optionsFinal: KingfisherOptionsInfo?
        if let options = options {
            optionsFinal = []
            for item in options {
                switch item {
                case .downloadPriority(let p):
                    optionsFinal?.append(.downloadPriority(p))
                case .forceRefresh:
                    optionsFinal?.append(.forceRefresh)
                case .fromMemoryCacheOrRefresh:
                    optionsFinal?.append(.fromMemoryCacheOrRefresh)
                case .forceTransition:
                    optionsFinal?.append(.forceTransition)
                case .cacheMemoryOnly:
                    optionsFinal?.append(.cacheMemoryOnly)
                case .waitForCache:
                    optionsFinal?.append(.waitForCache)
                case .onlyFromCache:
                    optionsFinal?.append(.onlyFromCache)
                case .backgroundDecode:
                    optionsFinal?.append(.backgroundDecode)
                case .callbackDispatchQueue(let queue):
                    optionsFinal?.append(.callbackDispatchQueue(queue))
                case .scaleFactor(let s):
                    optionsFinal?.append(.scaleFactor(s))
                case .preloadAllAnimationData:
                    optionsFinal?.append(.preloadAllAnimationData)
                case .keepCurrentImageWhileLoading:
                    optionsFinal?.append(.keepCurrentImageWhileLoading)
                case .onlyLoadFirstFrame:
                    optionsFinal?.append(.onlyLoadFirstFrame)
                case .cacheOriginalImage:
                        optionsFinal?.append(.cacheOriginalImage)
                }
            }
        }
        return optionsFinal
    }
    
    class func cacheTypeFromKingCacheType(cacheType: CacheType) -> LGCacheType {
        switch cacheType {
        case .none:
            return .none
        case .memory:
            return .memory
        default:
            return .disk
        }
    }
}



