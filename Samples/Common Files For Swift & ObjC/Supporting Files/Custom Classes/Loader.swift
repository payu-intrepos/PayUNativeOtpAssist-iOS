//
//  Loader.swift
//  PayUNativeOtpAssistSwiftSample
//
//  Created by Amit Salaria on 25/06/21.
//

import Foundation
import UIKit

class Loader: UIView {
        
    static let shared: Loader = {
        let instance = Loader()
        return instance
    }()
    
    private let loader = UIActivityIndicatorView()

    private override init(frame: CGRect) {
        super.init(frame: frame)
        prepared()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func prepared() {
        self.backgroundColor = UIColor.white.withAlphaComponent(0.5)
        self.frame = UIScreen.main.bounds
        loader.frame = UIScreen.main.bounds
        loader.style = .whiteLarge
        loader.center = self.center
        loader.color = .gray
        self.addSubview(loader)
        
    }
    
    func show() {
        let application = UIApplication.shared.delegate as! AppDelegate
        application.window?.addSubview(self)
        
        loader.startAnimating()
        loader.bringSubviewToFront((application.window?.rootViewController?.view)!)
    }
    
    func hide() {
        self.removeFromSuperview()
        loader.stopAnimating()
    }
    
}
