//
//  ViewController.swift
//  phw14-14-randomAPI-yesno
//
//  Created by jasonhung on 2023/12/23.
//

import UIKit

//PickerView步驟1，要加 UIPickerViewDelegate, UIPickerViewDataSource
class ViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    @IBOutlet weak var questionBgView: UIView!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var questionPickerView: UIPickerView!
    @IBOutlet weak var startButton: UIButton!
    
    var questions:[String] = []
    var yesNoText = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // 設置圓角
        questionBgView.layer.cornerRadius = 20 // 設置你想要的圓角半徑
        questionBgView.layer.masksToBounds = true // 這一行是確保內容在圓角範圍內顯示，不超出邊界
        activityIndicator.hidesWhenStopped = true
        
        //取得題目
        getYesOrNoQuestion()
        
        //PickerView步驟2，要設 delegate dataSource for pickerView
        questionPickerView.delegate = self
        questionPickerView.dataSource = self
    }
    
    
    func getYesOrNoQuestion(){
        
        fetchYesOrNoQuestion { result in
            print(result)

            DispatchQueue.main.async {
                guard let resultStrings = result as? [String] else {
                    print("Invalid result type")
                    return
                }
                
                self.questions = resultStrings
                print(self.questions)
                
                self.questionPickerView.reloadAllComponents()
            }
        }
    }
    
    //PickerView步驟3，要寫 protocol UIPickerViewDelegate, UIPickerViewDataSource 的程式
    // MARK: - UIPickerViewDataSource
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        print("questions.count=\(questions.count)")
        return questions.count
    }
    
    // MARK: - UIPickerViewDelegate
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return questions[row]
    }
    
    // MARK: -
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "resultSegueIdentifier" {
            if let resultVC = segue.destination as? resultViewController {
                
                // 在這裡傳遞任何需要的資料到 resultViewController
                let selectedRow = questionPickerView.selectedRow(inComponent: 0)
                resultVC.question = questions[selectedRow]
                resultVC.yesNoText = yesNoText.uppercased()
                resultVC.image = imageView.image!
            }
        }
    }
    
    
    @IBAction func start(_ sender: UIButton) {

        // 開始顯示指示器
        self.activityIndicator.transform = CGAffineTransform(scaleX: 3, y: 3)
        activityIndicator.startAnimating()
        startButton.isHidden = true
        
        getYesNO()
    }
    
    func showResultVC(){
        startButton.isHidden = false
        activityIndicator.stopAnimating()
        performSegue(withIdentifier: "resultSegueIdentifier", sender: self)
    }
    
    
    func getYesNO(){
        // 使用示例
        fetchYesNoData { result in
            switch result {
            case .success(let yesNoResponse):
                
                print("Answer: \(yesNoResponse.answer)")
                print("Forced: \(yesNoResponse.forced)")
                print("Image: \(yesNoResponse.image)")
                
                DispatchQueue.main.async {
                    // 設置圖片 URL
                    if let imageURL = URL(string: yesNoResponse.image) {
                        
                        self.imageView.kf.setImage(with: URL(string: yesNoResponse.image), completionHandler: { result in
                            switch result {
                            case .success(_):
                                // 圖片載入成功，可以在這裡執行你的程式碼
                                DispatchQueue.main.async {
                                    
                                    self.activityIndicator.stopAnimating() // 圖片載入成功，停止指示器
                                    self.yesNoText = yesNoResponse.answer
                                   
                                    self.showResultVC()
                                }
                                
                            case .failure(let error):
                                // 圖片載入失敗，你可以在這裡處理錯誤
                                print("載入圖片失敗：", error.localizedDescription)
                            }
                        })
                    }
                }
                
            case .failure(let error):
                print("錯誤：\(error.localizedDescription)")
                // 停止指示器
                self.activityIndicator.stopAnimating()
                self.activityIndicator.isHidden = true
            }
        }
    }
    
    
    func fetchYesNoData(completion: @escaping (Result<YesNoResponse, Error>) -> Void) {
        let jsonURL = URL(string: "https://yesno.wtf/api")!
        
        fetchData(from: jsonURL) { data in
            guard let data = data else {
                // 處理錯誤，這裡可以根據實際情況進行更多處理
                print("未獲得有效的 JSON 數據")
                completion(.failure(NSError(domain: "com.example", code: -1, userInfo: [NSLocalizedDescriptionKey: "未獲得有效的 JSON 數據"])))
                return
            }
            
            do {
                let decodedData = try JSONDecoder().decode(YesNoResponse.self, from: data)
                completion(.success(decodedData)) // 調用 completion handler 傳遞結果
            } catch {
                print("解碼 JSON 時發生錯誤:", error.localizedDescription)
                completion(.failure(error)) // 如果發生錯誤，可以傳遞錯誤對象
            }
        }
    }
}

