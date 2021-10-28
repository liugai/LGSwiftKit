//
//  LGImageAdapterConfig.swift
//  LGSwiftKit
//
//  Created by 刘盖 on 2021/10/27.
//

import Foundation

public typealias LGImageDownloadProgressBlock = ((_ receivedSize: Int64, _ totalSize: Int64) -> Void)
public typealias LGImageCompletionHandler = ((_ image: UIImage?, _ error: NSError?, _ cacheType: LGCacheType, _ imageURL: URL?) -> Void)

public enum LGCacheType {
    case none, memory, disk
    
    public var cached: Bool {
        switch self {
        case .memory, .disk: return true
        case .none: return false
        }
    }
}

public typealias LGImageAdapterOptionsInfo = [LGImageAdapterOptionsInfoItem]
public enum LGImageAdapterOptionsInfoItem {
    /// Associated `Float` value will be set as the priority of image download task. The value for it should be
    /// between 0.0~1.0. If this option not set, the default value (`NSURLSessionTaskPriorityDefault`) will be used.
    case downloadPriority(Float)
    
    /// If set, `Kingfisher` will ignore the cache and try to fire a download task for the resource.
    case forceRefresh

    /// If set, `Kingfisher` will try to retrieve the image from memory cache first. If the image is not in memory
    /// cache, then it will ignore the disk cache but download the image again from network. This is useful when
    /// you want to display a changeable image behind the same url, while avoiding download it again and again.
    case fromMemoryCacheOrRefresh
    
    /// If set, setting the image to an image view will happen with transition even when retrieved from cache.
    /// See `Transition` option for more.
    case forceTransition
    
    ///  If set, `Kingfisher` will only cache the value in memory but not in disk.
    case cacheMemoryOnly
    
    ///  If set, `Kingfisher` will wait for caching operation to be completed before calling the completion block.
    case waitForCache
    
    /// If set, `Kingfisher` will only try to retrieve the image from cache not from network.
    case onlyFromCache
    
    /// Decode the image in background thread before using.
    case backgroundDecode
    
    /// The associated value of this member will be used as the target queue of dispatch callbacks when
    /// retrieving images from cache. If not set, `Kingfisher` will use main queue for callbacks.
    case callbackDispatchQueue(DispatchQueue?)
    
    /// The associated value of this member will be used as the scale factor when converting retrieved data to an image.
    /// It is the image scale, instead of your screen scale. You may need to specify the correct scale when you dealing
    /// with 2x or 3x retina images.
    case scaleFactor(CGFloat)

    /// Whether all the animated image data should be preloaded. Default it false, which means following frames will be
    /// loaded on need. If true, all the animated image data will be loaded and decoded into memory. This option is mainly
    /// used for back compatibility internally. You should not set it directly. `AnimatedImageView` will not preload
    /// all data, while a normal image view (`UIImageView` or `NSImageView`) will load all data. Choose to use
    /// corresponding image view type instead of setting this option.
    case preloadAllAnimationData
    
    /// Keep the existing image while setting another image to an image view.
    /// By setting this option, the placeholder image parameter of imageview extension method
    /// will be ignored and the current image will be kept while loading or downloading the new image.
    case keepCurrentImageWhileLoading
    
    /// If set, Kingfisher will only load the first frame from a animated image data file as a single image.
    /// Loading a lot of animated images may take too much memory. It will be useful when you want to display a
    /// static preview of the first frame from a animated image.
    /// This option will be ignored if the target image is not animated image data.
    case onlyLoadFirstFrame
    
    /// If set and an `ImageProcessor` is used, Kingfisher will try to cache both
    /// the final result and original image. Kingfisher will have a chance to use
    /// the original image when another processor is applied to the same resource,
    /// instead of downloading it again.
    case cacheOriginalImage
}
