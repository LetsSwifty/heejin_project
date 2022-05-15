//
//  TheaterViewController.swift
//  MyMovieChart
//
//  Created by 김희진 on 2022/05/04.
//

import Foundation
import UIKit
import MapKit

class TheaterViewController: UIViewController {
  
    // 영화관 목록 화면에서 사용자가 선택한 값을 전달받을 변수.
    // 영화관 목록이 사용하는 데이터가 NSDictionary 타입으로 정의되어 있으므로(이거 한끌때메 어쩔 수 없음 ㅠ) 이를 전달받는 변수 역시 동일한 타입으로 정의해야 한다.
    var param: NSDictionary!

    @IBOutlet var map: MKMapView!
    
    override func viewDidLoad() {
        navigationItem.title = param["상영관명"] as? String
       
        //위도와 경도를 추출하여 Double값으로 캐스팅
        let lat = (param?["위도"] as! NSString).doubleValue
        let lng = (param?["경도"] as! NSString).doubleValue
        
        // 중심좌표정의
        let location = CLLocationCoordinate2D(latitude: lat, longitude: lng)

        // 지도에 표현될 거리, 값의 단위는 미터, 백미터 반경을 보여준다는 뜻
        let regionRadius: CLLocationDistance = 100

        // 거리를 반영한 지역 정보를 조합한 지도 데이터 생성
        let coordinateRegion = MKCoordinateRegion(center: location, latitudinalMeters: regionRadius, longitudinalMeters: regionRadius)
        
        // 지도를 화면에 표시
        map.setRegion(coordinateRegion, animated: true)
        
        // 위치를 표시해줄 객체를 생성
        let point = MKPointAnnotation()
        // 위치 표시객체에 가까 정의했던 중심 좌표를 넣어준다.
        point.coordinate = location
        // 위치 표현값을 추가
        map.addAnnotation(point)
    
    }
}
