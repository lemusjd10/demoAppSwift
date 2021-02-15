//
//  LoadingView.swift
//  Demo
//
//  Created by Julio Lemus on 14/02/21.
//

import Lottie
import Foundation

protocol LoadingViewPresentable {
    
    var isLoading: Bool { get }
    
    func showLoading()
    func hideLoading()
}

extension LoadingViewPresentable where Self: UIViewController {
    
    var isLoading: Bool {
        get {
            return isLoadingViewVisible
        }
    }
    
    func showLoading() {
        DispatchQueue.main.async {
            loadingView = LoadingView(frame: self.view.frame)
            isLoadingViewVisible = true
            
            if let window = UIApplication.shared.windows.filter({$0.isKeyWindow}).first {
                window.addSubview(loadingView)
            } else {
                self.view.addSubview(loadingView)
            }
        }
    }
    
    func hideLoading() {
        DispatchQueue.main.async {
            loadingView?.removeFromSuperview()
            isLoadingViewVisible = false
        }
    }
}

private var loadingView: LoadingView!
private var isLoadingViewVisible = false

private final class LoadingView: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        let window = UIApplication.shared.windows.filter {$0.isKeyWindow}.first
        let loadingView = UIView()
        loadingView.backgroundColor = UIColor.black.withAlphaComponent(0.75)
        let spinner = AnimationView(name: "catLoader")
        loadingView.addSubview(spinner)
        self.addSubview(loadingView)
        loadingView.frame = window?.frame ?? frame
        let size = loadingView.frame.width / 2
        spinner.frame = CGRect(origin: loadingView.center, size: CGSize(width: size, height: size))
        spinner.center = center
        spinner.loopMode = .loop
        spinner.play()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
