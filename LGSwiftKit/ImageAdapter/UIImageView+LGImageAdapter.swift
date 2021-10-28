//
//  UIImageView+LGImageAdapter.swift
//  LGSwiftKit
//
//  Created by 刘盖 on 2021/10/27.
//

import Kingfisher
public extension UIImageView {
    func lg_setImage(url: String?, placeholder: UIImage?, options:LGImageAdapterOptionsInfo? = nil, progressBlock: LGImageDownloadProgressBlock? = nil, completionHandler: LGImageCompletionHandler? = nil) {
        guard let url = url else {
            self.lg_cancelDownload()
            self.image = placeholder
            return
        }
        
        self.kf.setImage(with: URL(string: url), placeholder: placeholder, options: LGImageAdapter.convertOptionsToKingOptions(options: options)) { receivedSize, totalSize in
            if let progressBlock = progressBlock {
                progressBlock(receivedSize, totalSize)
            }
        } completionHandler: { image, error, cacheType, imageURL in
            if let completionHandler = completionHandler {
                completionHandler(image, error, LGImageAdapter.cacheTypeFromKingCacheType(cacheType: cacheType), imageURL)
            }
        }

    }
    
    func lg_cancelDownload() {
        self.kf.cancelDownloadTask()
    }
    
}
