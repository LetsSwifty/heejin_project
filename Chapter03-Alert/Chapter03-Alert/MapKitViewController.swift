//
//  MapKitViewController.swift
//  Chapter03-Alert
//
//  Created by 김희진 on 2022/09/10.
//

import UIKit
import MapKit

class MapKitViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        let mapKitView = MKMapView(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        self.view = mapKitView // 맵킷 뷰를 루트 뷰로 설정하는 코드다. 서브 뷰가 아닌 루트뷰인 경우 항상 화면 전체를 채우며, 좌표는 기본 0,0 이다. 그래서 w, h도 0 으로 했어도 된다
        self.preferredContentSize.height = 300 // 알림창은 contentVC의 정보를 읽어들일때 preferredContentSize속성을 참고하여 표현해야 할 크기가 얼마인지 계산한다.
        
        let pos = CLLocationCoordinate2D(latitude: 37.514322, longitude: 126.894623)
        let span = MKCoordinateSpan(latitudeDelta: 0.005, longitudeDelta: 0.005) // 지도에서 보여줄 축척, 숫자가 작을수록 확대률이 크다
        let region = MKCoordinateRegion(center: pos, span: span) // pos 와 span을 기반으로 지도 영역을 정의

        // 지도 표시
        mapKitView.region = region
        mapKitView.regionThatFits(region)
        
        // 핀 표시
        let point = MKPointAnnotation()
        point.coordinate = pos
        mapKitView.addAnnotation(point)
    }
}
