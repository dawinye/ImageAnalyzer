//
//  ViewController.swift
//  ImageAnalyzer
//
//  Created by Dawin Ye on 4/25/20.
//  Copyright © 2020 Dawin Ye. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UISearchBarDelegate {

    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var imageView: UIImageView!

    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var tagLabel: UILabel!
    @IBOutlet weak var textLabel: UILabel!
    @IBOutlet weak var confidenceLabel: UILabel!
    
    var concatenatedString = ""
    var photo = Photo()
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        searchBar.delegate = self
    }
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        let title = searchBar.text!
        searchBar.resignFirstResponder()
        photo.getData (search: title) {
            DispatchQueue.main.async {
                self.setImage(from: title)
                self.descriptionLabel.text = "What's in this \(self.photo.width) by \(self.photo.height) photo?"
                for object in self.photo.tags {
                    self.concatenatedString += object + ", "
                }
                self.tagLabel.text = self.concatenatedString
                self.textLabel.text = self.photo.text
                self.confidenceLabel.text = "Confidence Level: " + String(self.photo.confidence) + "%"
            }
        }
    }
    func setImage(from url: String) {
        guard let imageURL = URL(string: url) else { return }

            // just not to cause a deadlock in UI!
        DispatchQueue.global().async {
            guard let imageData = try? Data(contentsOf: imageURL) else { return }

            let image = UIImage(data: imageData)
            DispatchQueue.main.async {
                self.imageView.image = image
            }
        }
    }

}

