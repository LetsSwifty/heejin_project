//
//  TheatherListController.swift
//  MyMovieChart
//
//  Created by 김희진 on 2022/05/03.
//

import Foundation
import UIKit

class TheatherListController: UITableViewController {
    var list = [NSDictionary]()
    
    var startPoint = 0
    
    override func viewDidLoad() {
        self.callAPI()
    }
    
    func callAPI(){
        let requsetURL = "http://swiftapi.rubypaper.co.kr:2029/theater/list"
        let sList = 100
        let type = "json"
        let urlObj = URL(string: "\(requsetURL)?s_page=\(self.startPoint)&s_list=\(sList)&type=\(type)")
        
        do {
            //NSString 객체를 이용하여 api 를 호출하고 그 결과값을 인코딩된 문자열로 받아온다.
            //키값이 한글로 되어있어서 인코딩 처리를 해야하는데, 이때 Data 객체 대신 NSString 객체를 이용하여 0x80_000_422로 인코딩처리를 함
            let stringdata = try NSString(contentsOf: urlObj!, encoding: 0x80_000_422)
 
            // 문자열로 받은 데이터를 utf-8로 인코딩한 Data로 반환한다.
            // 이때도 문자열의 인코딩 타입이 한글이기 때문에, 인코딩 처리가 필요하다..
            let encdata = stringdata.data(using: String.Encoding.utf8.rawValue)
            
            do {
                // JSON 형태로 읽어온 Data 객체를 JSONSerialization를 사용해서 NSArray로 파싱
                let apiArray = try JSONSerialization.jsonObject(with: encdata!, options: []) as? NSArray
            
                for obj in apiArray! {
                    list.append(obj as! NSDictionary)
                }
                
            }catch {
                
                let alert = UIAlertController(title: "실해", message: "데이터 분석이 실패하였습니다", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "확인", style: .cancel))
                
                present(alert, animated: false)
            }

            // do~try블록은 do 도중에 오류가 발생할경우 바로 catch로 넘어감. 그래서 블록 아래에 작성함( 계속 파싱 못할거니까 .. )
            startPoint += sList
            
        }catch {
            let alert = UIAlertController(title: "실해", message: "데이터를 불러오는데 실패하였습니다", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "확인", style: .cancel))
            
            present(alert, animated: false)

        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return list.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
 
        let obj = list[indexPath.row]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "tCell") as! TheaterCell
        cell.name?.text = obj["상영관명"] as? String
        cell.tel?.text = obj["연락처"] as? String
        cell.addr?.text = obj["소재지도로명주소"] as? String

        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "segue_map" {
            let path = self.tableView.indexPath(for: sender as! UITableViewCell)
            let data = self.list[path!.row]
            
            (segue.destination as? TheaterViewController)?.param = data
        }
    }
}

