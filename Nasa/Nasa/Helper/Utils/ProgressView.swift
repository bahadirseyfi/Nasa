//
//  ProgressView.swift
//  Nasa
//
//  Created by bahadir on 10.09.2021.
//

import UIKit
import NVActivityIndicatorView

final class ProgressView {
    static var shared = ProgressView()
    private init() {}
    private var isShowing = false
    
    private var keyWindow: UIWindow? = UIApplication.shared.windows.filter { $0.isKeyWindow }.first
    
    private lazy var progressHud: NVActivityIndicatorView = {
        let indicatorView = NVActivityIndicatorView(frame: CGRect(x: UIScreen.main.bounds.midX-50, y: UIScreen.main.bounds.midY-50, width: 100, height: 100), type: .ballScaleRippleMultiple, color: .nasaOrange, padding: .pi)
        return indicatorView
    }()

    func show() {
        guard !isShowing else { return }
        progressHud.startAnimating()
        keyWindow?.addSubview(progressHud)
        isShowing = true
    }
    
    func hide() {
        guard isShowing else { return }
        progressHud.stopAnimating()
        progressHud.removeFromSuperview()
        isShowing = false
    }
}
