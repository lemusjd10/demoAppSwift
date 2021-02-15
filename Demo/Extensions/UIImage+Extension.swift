//
//  UIImage+Extension.swift
//  Demo
//
//  Created by Julio Lemus on 13/02/21.
//

import Foundation
import UIKit

extension UIImage {
    
    convenience init?(base64String: String) {
        guard let decodedData = Data(base64Encoded: base64String, options: Data.Base64DecodingOptions.init(rawValue: 0)) else {
            return nil
        }
        
        self.init(data: decodedData)
    }
    
    func toBase64(quality:CGFloat? = nil) -> String? {
        guard let imageData = self.jpegData(compressionQuality: quality ?? 0.80) else { return nil }
        return imageData.base64EncodedString(options: [])
    }
    
    func convertImageToBase64String (quality: CGFloat? = nil) -> String {
        return self.jpegData(compressionQuality: quality ?? 0.80)?.base64EncodedString() ?? ""
    }
}
 
extension UIImageView {
    var contentClippingRect: CGRect {
        guard let image = image else { return bounds }
        guard contentMode == .scaleAspectFit else { return bounds }
        guard image.size.width > 0 && image.size.height > 0 else { return bounds }

        let scale: CGFloat
        if image.size.width > image.size.height {
            scale = bounds.width / image.size.width
        } else {
            scale = bounds.height / image.size.height
        }

        let size = CGSize(width: image.size.width * scale, height: image.size.height * scale)
        let x = (bounds.width - size.width) / 2.0
        let y = (bounds.height - size.height) / 2.0

        return CGRect(x: x, y: y, width: size.width, height: size.height)
    }
}
