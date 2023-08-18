//
//  ViewHelper.swift
//  WanderView
//
//  Created by Steve Hechio on 16/08/2023.
//

import Foundation
import UIKit
import SwiftUI


// MARK: - View Helper

struct ViewHelper {
    // Create a Label
    static func createLabel(with color: UIColor, text: String, alignment: NSTextAlignment, font: UIFont) -> UILabel {
        
        let newLabel = UILabel()
        newLabel.textColor = color
        newLabel.text = text
        newLabel.textAlignment = alignment
        newLabel.font = font
        newLabel.translatesAutoresizingMaskIntoConstraints = false
        return newLabel
    }
    
    // Create a Stack View
    static func createStackView(_ axis: NSLayoutConstraint.Axis, distribution: UIStackView.Distribution) -> UIStackView {
        let stackView = UIStackView()
        stackView.axis = axis
        stackView.distribution = distribution
        stackView.alignment = .center
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }
    
    // Create an empty UIView
    static func createEmptyView() -> UIView {
        let newView = UIView()
        newView.translatesAutoresizingMaskIntoConstraints = false
        return newView
    }
    
    // Create an ImageView
    static func createImageView() -> UIImageView {
        let newImageView = UIImageView()
        newImageView.contentMode = .scaleAspectFit
        newImageView.backgroundColor = .clear
        newImageView.clipsToBounds = true
        newImageView.translatesAutoresizingMaskIntoConstraints = false
        return newImageView
    }
    
    //Create a CollectionView
    
    static func createCollectionView() -> UICollectionView {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }
    
    static func createPageControl() -> UIPageControl {
        let pageControl = UIPageControl()
        pageControl.backgroundColor = UIColor(named: "background")
        pageControl.layer.cornerRadius = 12
        return pageControl
    }
}

// MARK: - UIView Extension

extension UIView {
    
    // Constraining Methods
    func setHeightContraint(by constant: CGFloat) -> NSLayoutConstraint {
        return heightAnchor.constraint(equalToConstant: constant)
    }
    
    func setWidthContraint(by constant: CGFloat) -> NSLayoutConstraint {
        return widthAnchor.constraint(equalToConstant: constant)
    }
    
}


// MARK: - UIImageView Extension

extension UIImageView {
    
    func loadImage(from urlString: String) {
        guard let url = URL(string: urlString) else { return }
        if let cachedResponse = URLCache.shared.cachedResponse(for: URLRequest(url: url)),
           let image = UIImage(data: cachedResponse.data) {
            self.image = image
            return
        }

        let loadingActivityIndicator = UIActivityIndicatorView(style: .medium)
        loadingActivityIndicator.startAnimating()
        loadingActivityIndicator.center = CGPoint(x: self.bounds.midX, y: self.bounds.midY)
        loadingActivityIndicator.tag = 23
        self.addSubview(loadingActivityIndicator)
        
        NSLayoutConstraint.activate([
            loadingActivityIndicator.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            loadingActivityIndicator.centerYAnchor.constraint(equalTo: self.centerYAnchor)
        ])

        URLSession.shared.dataTask(with: url) { [weak self] (data, response, error) in
            guard let self = self, let data = data, error == nil,
                  let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200,
                  let image = UIImage(data: data) else {
                return
            }
            
            let cachedData = CachedURLResponse(response: response!, data: data)
            URLCache.shared.storeCachedResponse(cachedData, for: URLRequest(url: url))

            DispatchQueue.main.async {
                self.subviews.forEach { $0.removeFromSuperview() }
                self.image = image
            }
        }.resume()
    }

    
    func makeCircular() {
        self.contentMode = .scaleAspectFill
        self.layer.cornerRadius = self.frame.size.width / 2
        self.clipsToBounds = true
        self.layer.borderWidth = 2.0
        self.layer.borderColor = UIColor.white.cgColor
    }
    
    func load(url: URL, placeholder: UIImage? = nil) {
        self.image = placeholder
        URLSession.shared.dataTask(with: url) { data, _, _ in
            if let data = data, let image = UIImage(data: data) {
                DispatchQueue.main.async {
                    self.image = image
                }
            }
        }.resume()
    }
}


