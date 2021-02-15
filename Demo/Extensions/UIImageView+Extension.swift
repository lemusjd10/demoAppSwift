//
//  UIImageView+Extension.swift
//  Demo
//
//  Created by Julio Lemus on 13/02/21.
//

import UIKit
import Kingfisher

extension UIImageView {
    func roundedAndBoder(color: UIColor? = nil, borderSize:CGFloat? = nil, radius:CGFloat? = nil, mode:ContentMode? = nil){
        self.clipsToBounds = true
        self.layer.borderWidth = borderSize ?? 2
        self.layer.borderColor = color?.cgColor ?? UIColor.clear.cgColor
        self.layer.cornerRadius = radius ?? 8
        self.layer.masksToBounds = true
        self.contentMode = mode ?? ContentMode.scaleAspectFit
    }
    
    func downloadImage(url:String,placeholderImage:UIImage? = nil, loader:IndicatorType? = nil){
        self.clipsToBounds = true
        let resizingProcessor = DownsamplingImageProcessor(size: bounds.size)
        let url = URL(string:url)
        kf.indicatorType = loader ?? .none
        kf.setImage(with: url, options: [
            .processor(resizingProcessor),
            .scaleFactor(UIScreen.main.scale),
            .transition(.fade(1)),
            .cacheOriginalImage
        ]) { (valu1, value2) in 
        } completionHandler: { (resul) in
            switch resul {
            case .success(_): break
                //debugPrint("Task done for: \(value.source.url?.absoluteString ?? "")")
            case .failure(_): break
                //debugPrint("Download Image failed: \(error.localizedDescription)")
            }
        }
    }
    
    func downloadImageProgress(url:String, placeHolder:UIImage? = nil, loader:IndicatorType? = nil) {
        let url = URL(string:url)
        self.kf.indicatorType = loader ?? .none
        self.kf.setImage(with: url, placeholder: placeHolder, options: [.transition(.fade(1)), .backgroundDecode]) { result in
            print(result)
            print("Image \(String(describing: url)) Finished")
        }
    }
}
