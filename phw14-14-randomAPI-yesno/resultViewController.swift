//
//  resultViewController.swift
//  phw14-14-randomAPI-yesno
//
//  Created by jasonhung on 2023/12/23.
//

import UIKit
import Kingfisher


struct YesNoResponse: Codable {
    let answer: String
    let forced: Bool
    let image: String
}

class resultViewController: UIViewController {
    
    var question = ""
    var yesNoText = ""
    var image = UIImage()
    
    @IBOutlet weak var questionBgView: UIView!
    @IBOutlet weak var yesNoTextView: UITextView!
    @IBOutlet weak var questionTextView: UITextView!
    @IBOutlet weak var imageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // 設置圓角
        questionBgView.layer.cornerRadius = 20 
        questionBgView.layer.masksToBounds = true
        
        questionTextView.text = "占卜的問題\n\n\(question)"
        yesNoTextView.text = yesNoText
        let resource: Resource? = nil
        imageView.kf.setImage(with: resource) // inform kingfisher that you are assigning this image by your own
        imageView.image = image
        
    }
    
    
    @IBAction func closeBTN(_ sender: UIButton) {
        // 關閉 resultViewController
        self.dismiss(animated: true, completion: nil)
    }
    
    
    
}
