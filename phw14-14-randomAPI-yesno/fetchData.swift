//
//  fetchData.swift
//  phw14-2-json-decode
//
//  Created by jasonhung on 2023/12/20.
//

import Foundation

func fetchData(from url: URL, completion: @escaping (Data?) -> Void) {
    URLSession.shared.dataTask(with: url) { data, response, error in
        guard let data = data, error == nil else {
            print("取得 JSON 時發生錯誤:", error?.localizedDescription ?? "未知錯誤")
            completion(nil)
            return
        }
        completion(data)
    }.resume()
}
