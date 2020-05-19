//
// Created by 6ai on 21/04/2020.
// Copyright (c) 2020 6ai. All rights reserved.
//

import UIKit

class ImageViewController: UIViewController, UIScrollViewDelegate {
    private var imageView = UIImageView()
    private let activityIndicator = UIActivityIndicatorView()
    // fixme scroll view
    var imageURL: URL? { didSet { fetchImage() } }

    private var image: UIImage? {
        get {
            return imageView.image
        }
        set {
            activityIndicator.stopAnimating()
            imageView.image = newValue
            imageView.sizeToFit()
            let size = newValue?.size ?? CGSize.zero
            scrollView.contentSize = size
            scrollViewHeight?.constant = size.height
            scrollViewWidth?.constant = size.width
        }
    }

    private func fetchImage() {
        activityIndicator.startAnimating()
        DispatchQueue.global(qos: .utility).async {
            guard let url = self.imageURL, let imageData = try? Data(contentsOf: url) else { return }
            DispatchQueue.main.async {
                self.image = UIImage(data: imageData)
            }
        }

    }

    private var scrollViewWidth: NSLayoutConstraint?
    private var scrollViewHeight: NSLayoutConstraint?

    let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.minimumZoomScale = 1 / 25
        scrollView.maximumZoomScale = 2
        return scrollView
    }()

    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageView
    }

    func scrollViewDidZoom(_ scrollView: UIScrollView) {
        scrollViewWidth?.constant = scrollView.contentSize.width
        scrollViewHeight?.constant = scrollView.contentSize.height
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(scrollView)
        scrollView.addSubview(imageView)
        imageView.addSubview(activityIndicator)

        scrollView.delegate = self
        setupAutolayout()
    }

    private func setupAutolayout() {

        activityIndicator.anchor(top: imageView.topAnchor, left: imageView.leftAnchor,
                bottom: imageView.bottomAnchor, right: imageView.rightAnchor)

        let imageViewSize = imageView.frame.size


        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollViewWidth = scrollView.widthAnchor.constraint(equalToConstant: imageViewSize.width)
        scrollViewHeight = scrollView.heightAnchor.constraint(equalToConstant: imageViewSize.height)

        scrollViewWidth?.isActive = true
        scrollViewHeight?.isActive = true

        NSLayoutConstraint.activate(
                [scrollView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                 scrollView.centerYAnchor.constraint(equalTo: view.centerYAnchor)]
        )

    }
}
