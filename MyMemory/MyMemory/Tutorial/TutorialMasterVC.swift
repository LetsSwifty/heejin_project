//
//  TutorialMasterVC.swift
//  MyMemory
//
//  Created by 김희진 on 2022/10/03.
//

import Foundation

class TutorialMasterVC: UIViewController, UIPageViewControllerDataSource {
    var pageVC: UIPageViewController! // 스토리보드에 추가한 PageViewController 변수
    
    var contenTitle = ["STEP1", "STEP2", "STEP3", "STEP4"]
    var contentsImages = ["page0", "page1", "page2", "page3"]
    
    @IBAction func close(_ sender: UIButton) {
        let ud = UserDefaults.standard
        ud.set(true, forKey: UserInfoKey.tutorial)
        ud.synchronize()
        
        self.presentingViewController?.dismiss(animated: true)
    }
    
    override func viewDidLoad() {
        
        self.pageVC = self.instanceTutorialVC(name: "PageVC") as? UIPageViewController //4개의 컨텐츠를 관리할 PageViewController을 생성한다.
        self.pageVC.dataSource = self
        
        let startContentVC = self.getContentVC(atIndex: 0)! // 최초로 노출될 컨텐츠0
        self.pageVC.setViewControllers([startContentVC], direction: .forward, animated: true)
        
        // 페이지 뷰 컨트롤러는 self인 TutorialMasterVC 위에 표시되므로, 페이지 뷰 컨트롤러가 출력될 영역을 지정해주어야 한다.
        self.pageVC.view.frame.origin = CGPoint(x: 0, y: 0)
        self.pageVC.view.frame.size.width = self.view.frame.width
        self.pageVC.view.frame.size.height = self.view.frame.height - 200 // 시작하기 버튼 보이기 위해 이만큼 띄운다

        // 페이지 뷰 컨트롤러를 마스터 뷰 컨트롤러의 자식 뷰 컨트롤러로 설정
        self.addChild(self.pageVC)
        self.view.addSubview(self.pageVC.view)
        self.pageVC.didMove(toParent: self) // 자식 뷰 컨트롤러에게 부모 뷰 컨트롤러가 바뀌었음을 알려준다.
    }
    
    func getContentVC(atIndex idx: Int) -> UIViewController? {
        // 인덱스 유효성 체크
        guard self.contenTitle.count >= idx && self.contenTitle.count > 0 else { return nil }
        
        guard let cvc = self.instanceTutorialVC(name: "ContentsVC") as? TutorialContentsVC else { return nil }
        cvc.titleText = self.contenTitle[idx]
        cvc.imageFile = self.contentsImages[idx]
        cvc.pageIndex = idx
        return cvc
    }
 
    //이 두 델리게이트 메소드들은 사용자가 페이지를 스크롤할 때마다 방향에 맞게 호출ㅇ되어 각각 다음 페이지를 준비하는 역할을 담당한다.
    //둘다 viewController 인자는 현재 선택되어있는 페이지이다.
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        //현재의 뷰컨보다 앞쪽에 올 콘텐츠 뷰 컨트롤러 객체
        guard var index = (viewController as! TutorialContentsVC).pageIndex else { return nil }
        guard index > 0 else { return nil }
        
        index -= 1
        return self.getContentVC(atIndex: index)
    }
    
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        //현재의 뷰컨보다 뒤쪽에 올 콘텐츠 뷰 컨트롤러 객체
        guard var index = (viewController as! TutorialContentsVC).pageIndex else { return nil }
        index += 1
        
        guard index < self.contenTitle.count else { return nil }
        return self.getContentVC(atIndex: index)
    }

    // 요 두개 함수는 인디케이터를 위한 코드이다. 위에는 페이지가 몇개인지 알려주는 코드이고, 아래는 첫번째 선택되어있는 페이지 정보를 리턴해준다.
    func presentationCount(for pageViewController: UIPageViewController) -> Int {
        return self.contenTitle.count
    }

    func presentationIndex(for pageViewController: UIPageViewController) -> Int {
        return 0
    }
}

