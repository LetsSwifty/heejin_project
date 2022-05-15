//
//  ListViewController.swift
//  MyMovieChart
//
//  Created by 김희진 on 2022/04/26.
//

import UIKit

class ListViewController: UITableViewController {

    var dataset = [("다크나이트", "영웅물에 철학에 음악까기 더해져 예술이 된다.", "2008-09-04", 9.41, "nil"),
                   ("다크나이트", "영웅물에 철학에 음악까기 더해져 예술이 된다.", "2008-09-05", 9.41, "nil"),
                   ("다크나이트", "영웅물에 철학에 음악까기 더해져 예술이 된다.", "2008-09-06", 9.41, "nil")]

    var page = 1
    
    lazy var list: [MovieVO] = {
        var dataList = [MovieVO]()
        for (title, desc, opendate, rating, thumbnail) in self.dataset {
            var mvo = MovieVO()
            mvo.title = title
            mvo.description = desc
            mvo.opendate = opendate
            mvo.rating = rating
            mvo.thumbnail = thumbnail
            
            dataList.append(mvo)
        }
        return dataList
    }()
    
    @IBOutlet var moreButton: UIButton!
    
    override func viewDidLoad() {
        
       callMovieAPI()

        
//스태틱 셀일때만 쓰인다.
//        tableView.register(MovieCell.self, forCellReuseIdentifier: "MovieCell")
//        if #available(iOS 15.0, *) {
//            tableView.sectionHeaderTopPadding = 0.0
//        } else {
//            // Fallback on earlier versions
//        }


//        var mvo = MovieVO()
//        mvo.title = "다크나이트"
//        mvo.description = "영웅물에 철학에 음악까지 더해져 예술이 되다."
//        mvo.opendate = "2009-09-04"
//        mvo.rating = 9.89
//        self.list.append(mvo)
//
//
//        mvo = MovieVO()
//        mvo.title = "호무시절"
//        mvo.description = "때를 알고 내리는 좋은 비"
//        mvo.opendate = "2009-07-14"
//        mvo.rating = 7.91
//        self.list.append(mvo)
//
//
//        mvo = MovieVO()
//        mvo.title = "말할 수 없는 비밀"
//        mvo.description = "여기서 너까지 다섯 걸음"
//        mvo.opendate = "2015-10-31"
//        mvo.rating = 9.19
//        self.list.append(mvo)
    }
    
    func callMovieAPI(){
        
        let url = "http://swiftapi.rubypaper.co.kr:2029/hoppin/movies?version=1&page=\(self.page)&count=30&genreId=&order=releasedateasc"
        let apiURI: URL! = URL(string: url)
        
        let apiData = try! Data(contentsOf: apiURI)
 
        // apiData에 저장된 데이터를 출력하기 위해 NSString타입의 문자열로 변환해야함.
        // 두번째 파라미터 encoding이 인코딩 형식이다.
        let log = NSString(data: apiData, encoding: String.Encoding.utf8.rawValue) ?? ""
        NSLog("API Result=\(log)")
        
        do{
            // api호출결과는 Data 타입이여서 로그를 출력하기 위해 NSString 으로 변환하였듯이, 테이블을 구성하는 데이터로 사용하려면 NSDictionary 객체로 변환해야한다.
            // NSDictionary 객체는 키-값 쌍으로 되어있어 JSONObject와 호환이 된다.
            // 만약 데이터가 리스트 형해로 전달되었다면 NSArray객체를 이용해야한다.
            // 파싱할 떄는 jsonObject를 이용한다. 근데 jsonObject는 파싱 과정에서 오류가 발생하면 이를 예외로 던지게 설계되어 있어 do~try~catch 구문으로 감싸줘야한다.
            // jsonObject실행 결과로 NSDictionary, NSArray 형태가 나온다. 양쪽을 모두 지원하기 위해 jsonObject 은 Any를 리턴하므로 이 결과값을 원하는 값으로 캐스팅해서 받아야한다.
            let apiDictionary = try JSONSerialization.jsonObject(with: apiData, options: []) as! NSDictionary
            let hoppin = apiDictionary["hoppin"] as! NSDictionary
            let totalCount = (hoppin["totalCount"] as? NSString)!.integerValue
            let movies = hoppin["movies"] as! NSDictionary
            let movie = movies["movie"] as! NSArray
            
            for row in movie {
                let r = row as! NSDictionary
                let mvo = MovieVO()
                
                mvo.title = r["title"] as? String
                mvo.description = r["genreNames"] as? String
                mvo.thumbnail = r["thumbnailImage"] as? String
                mvo.detail = r["linkUrl"] as? String
                mvo.rating = ((r["ratingAverage"] as! NSString).doubleValue)
                
                let url: URL! = URL(string: mvo.thumbnail!)
                
                print(url)
                let imageData = try! Data(contentsOf: url)
                mvo.thumbnailImage = UIImage(data: imageData)
                
                list.append(mvo)
            }
            
            if list.count > totalCount {
                self.moreButton.isHidden = true
            }
                        
        }catch{
            NSLog("Parse Error!!")
        }
        
    }
    
    @IBAction func more(_ sender: Any) {
        self.page += 1
        callMovieAPI()
        self.tableView.reloadData()
    }
    
    func getThumbnailImage(_ index: Int) -> UIImage {
        
        let mvo = list[index]
        
        // 메모제이션 : 저장된 이미지가 있으면 그걸 반환하고, 없을경우 일단 mvo객체에 저장한 후 반환
        if let savedImage = mvo.thumbnailImage {
            return savedImage
        }else{

            let url: URL! = URL(string: mvo.thumbnail!)
            let imageData = try! Data(contentsOf: url)
            mvo.thumbnailImage = UIImage(data: imageData)
            
            return mvo.thumbnailImage!
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return list.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        //셀에 들어갈 데이터
        let row = list[indexPath.row]

        //재사용 큐를 이용해 테1이블 뷰 셀 인스턴스 생성
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "MovieCell", for: indexPath) as? MovieCell else {
            fatalError("not found")
        }
        
        cell.title.text = row.title
        cell.desc.text = row.description
        cell.opendate.text = row.opendate
        cell.rate.text = "\(row.rating!)"
 
        DispatchQueue.main.async {
            if indexPath.row < 3 {
                cell.thumbnail.image = UIImage(named: row.thumbnail!)
            } else {
                cell.thumbnail.image = self.getThumbnailImage(indexPath.row)
            }
        }
        
// 커스텀 셀을 태그를 이용해서 사용. 따로 셀 클래스를 만들지 않고 identifier로 구분했다.
//        let title = cell.viewWithTag(101) as? UILabel
//        let desc = cell.viewWithTag(102) as? UILabel
//        let opendate = cell.viewWithTag(103) as? UILabel
//        let rating = cell.viewWithTag(104) as? UILabel
//
//        title?.text = row.title
//        desc?.text = row.description
//        opendate?.text = row.opendate
//        rating?.text = "\(row.rating!)"

// 스태틱 셀
//        cell.textLabel?.text = row.title
//        cell.detailTextLabel?.text = row.description
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        NSLog("선택된 행은 \(indexPath.row) 번째 행입니다.")
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
 }

extension ListViewController {
    // 화면 전환시 값을 넘겨주기 위한 세그웨이 관련 처리를 한다. 세그웨이 액션 실행 전에 call 되는 메소드
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "segue_detail" {

            // 사용작사 클릭한 행을 찾아낸다.
            let path = tableView.indexPath(for: sender as! MovieCell)

            // 세그의 목적지 VC에 list에서 꺼낸 데이터를 넣는다.
            let detailVC = segue.destination as? DetailViewController
            detailVC?.mvo = list[path!.row]
        }
    }
}
