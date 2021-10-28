//
//  UIButton+LGImageAdapter.swift
//  LGSwiftKit
//
//  Created by 刘盖 on 2021/10/27.
//

import Kingfisher
public extension UIButton {
    
    func lg_setImage(url: String?,
                     for state: UIControl.State,
                     placeholder: UIImage? = nil,
                     options: LGImageAdapterOptionsInfo? = nil,
                     progressBlock: LGImageDownloadProgressBlock? = nil,
                     completionHandler: LGImageCompletionHandler? = nil) {
        guard let url = url else {
            self.lg_cancelImageDownload()
            self.setImage(placeholder, for: state)
            return
        }
        
        self.kf.setImage(with: URL(string: url), for: state, placeholder: placeholder, options: LGImageAdapter.convertOptionsToKingOptions(options: options)) { receivedSize, totalSize in
            if let progressBlock = progressBlock {
                progressBlock(receivedSize, totalSize)
            }
        } completionHandler: { image, error, cacheType, imageURL in
            if let completionHandler = completionHandler {
                completionHandler(image, error, LGImageAdapter.cacheTypeFromKingCacheType(cacheType: cacheType), imageURL)
            }
        }

    }
    
    func lg_setBackgroudImage(url: String?,
                     for state: UIControl.State,
                     placeholder: UIImage? = nil,
                     options: LGImageAdapterOptionsInfo? = nil,
                     progressBlock: LGImageDownloadProgressBlock? = nil,
                     completionHandler: LGImageCompletionHandler? = nil) {
        guard let url = url else {
            self.lg_cancelBackgroudImageDownload()
            self.setImage(placeholder, for: state)
            return
        }
        
        self.kf.setBackgroundImage(with: URL(string: url), for: state, placeholder: placeholder, options: LGImageAdapter.convertOptionsToKingOptions(options: options)) { receivedSize, totalSize in
            if let progressBlock = progressBlock {
                progressBlock(receivedSize, totalSize)
            }
        } completionHandler: { image, error, cacheType, imageURL in
            if let completionHandler = completionHandler {
                completionHandler(image, error, LGImageAdapter.cacheTypeFromKingCacheType(cacheType: cacheType), imageURL)
            }
        }

    }
    
    func lg_cancelImageDownload() {
        self.kf.cancelImageDownloadTask()
    }
    
    func lg_cancelBackgroudImageDownload() {
        self.kf.cancelBackgroundImageDownloadTask()
    }
    
}

