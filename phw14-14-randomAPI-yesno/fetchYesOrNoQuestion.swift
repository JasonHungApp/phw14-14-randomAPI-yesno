//
//  AppleMarketingRssFeed.swift
//  phw14-2-json-decode
//
//  Created by jasonhung on 2023/12/20.
//

import Foundation

/*
 https://raw.githubusercontent.com/JasonHungApp/JSON_API/main/YesOrNoQuestion
 [
 我的運勢好嘛？,
 最近愛情運好嗎？,
 今天財運如何？,
 尾牙會中大獎嗎？,
 今天要買股票嗎？,
 考試會順利嗎？
 ]

 */



struct Question: Codable {
    var question: String
}

let yesOrNoQuestionURL = URL(string: "https://raw.githubusercontent.com/JasonHungApp/JSON_API/main/YesOrNoQuestion")! // Replace with the actual URL or local file URL


func fetchYesOrNoQuestion(completion: @escaping ([Question]) -> Void) {
    let jsonURL = yesOrNoQuestionURL // 替換為實際的 JSON URL

    fetchData(from: jsonURL) { data in
        guard let data else {
            // 處理錯誤，這裡可以根據實際情況進行更多處理
            print("未獲得有效的 JSON 數據")
            return
        }

        do {
            
            var decodedData = try JSONDecoder().decode([Question].self, from: data)
            completion(decodedData) // 調用 completion handler 傳遞結果
            
        } catch {
            print("解碼 JSON 時發生錯誤:", error.localizedDescription)
            completion([]) // 如果發生錯誤，可以傳遞一個空的Question陣列或其他預設值
        }
    }
}
