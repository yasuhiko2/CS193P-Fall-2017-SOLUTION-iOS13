//
//  ImageGalleryCollectionViewCell.swift
//  ImageGallery
//
//  Created by ccoleridge on 11/04/2020.
//  Copyright © 2020 ccoleridge. All rights reserved.
//

import UIKit

class ImageCell: UICollectionViewCell {

    // MARK: - Properties
    private(set) var width: CGFloat?
    private(set) var height: CGFloat?

    private var image: UIImage?
    private let fetcher: ImageFetcher = ImageFetcher.shared
    var imageURL: URL? {
        didSet {
            if let imageURL = imageURL {
                image = fetcher.fetchImage(with: imageURL)
            }
        }
    }

    // MARK: - Lifecycle
    override func layoutSubviews() {
        print(#function, Self.self)
        super.layoutSubviews()
        subviews.forEach({ $0.removeFromSuperview() })
        if image != nil {
            let imageView = UIImageView(image: image)
            addSubview(imageView)
            imageView.anchor(top: topAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor)
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}