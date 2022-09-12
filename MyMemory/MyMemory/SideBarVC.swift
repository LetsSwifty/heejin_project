//
//  SideBarVC.swift
//  MyMemory
//
//  Created by 김희진 on 2022/09/12.
//

import UIKit

class SideBarVC: UITableViewController {
    
    let titles = ["새글 작성하기", "친구 새글", "달력으로 보기", "공지사항", "통계", "계정 관리"]
    let icons = [UIImage(named: "icon01.png"), UIImage(named: "icon02.png"), UIImage(named: "icon03.png"), UIImage(named: "icon04.png"), UIImage(named: "icon05.png"), UIImage(named: "icon06.png")]

    let nameLabel = UILabel()
    let emailLabel = UILabel()
    let profileImage = UIImageView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
 
        // 헤더 뷰 생성
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 70))
        headerView.backgroundColor = .gray
        self.tableView.tableHeaderView = headerView
        
        self.nameLabel.frame = CGRect(x: 70, y: 15, width: 100, height: 30)
        self.nameLabel.text = "꼼꼼한 재은씨"
        self.nameLabel.textColor = .white
        self.nameLabel.font = .boldSystemFont(ofSize: 15)
        self.nameLabel.backgroundColor = .clear
        headerView.addSubview(self.nameLabel)
        
        self.emailLabel.frame = CGRect(x: 70, y: 30, width: 100, height: 30)
        self.emailLabel.text = "heejin@naver.com"
        self.emailLabel.textColor = .white
        self.emailLabel.font = .systemFont(ofSize: 11)
        self.emailLabel.backgroundColor = .clear
        headerView.addSubview(self.emailLabel)
        
        let profile = UIImage(named: "account.jpg")
        self.profileImage.image = profile
        self.profileImage.frame = CGRect(x: 10, y: 10, width: 50, height: 50)
        self.profileImage.layer.cornerRadius = self.profileImage.frame.width / 2
        self.profileImage.layer.borderWidth = 0
        self.profileImage.layer.masksToBounds = true
        headerView.addSubview(profileImage)
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.titles.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let id = "menuCell"
        let cell = tableView.dequeueReusableCell(withIdentifier: id) ?? UITableViewCell(style: .default, reuseIdentifier: id)
        
        cell.textLabel?.text = self.titles[indexPath.row]
        cell.textLabel?.font = .systemFont(ofSize: 14)
        cell.imageView?.image = self.icons[indexPath.row]

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            // 목적지VC를 가져온다
            let uv = self.storyboard?.instantiateViewController(withIdentifier: "MemoForm")

            //self.revealViewController() 는 메인 컨트롤러 객체를 가져와준다. 이를 통해 얻어온 메인컨트롤러에 정의된 frontViewController 를 읽어오고, 그걸 네비게이션으로 타입 캐스팅을 해준다. -> Push 해야하기 때문에
            let target = self.revealViewController().frontViewController as! UINavigationController
            target.pushViewController(uv!, animated: true)

            // 사이드 바를 닫아주는 메소드이다. 이것도 revealViewController 에 정의된 메소드이기 때문에 참조해서 호출한다. 이 메소드는 열려있을때는 닫히고, 닫혀있을때는 열린다.
            self.revealViewController().revealToggle(self)

        } else if indexPath.row == 5 {
            
            let uv = self.storyboard?.instantiateViewController(withIdentifier: "_Profile")
            uv?.modalPresentationStyle = .overFullScreen
            self.present(uv!, animated: true) {
                self.revealViewController().revealToggle(self)
            }
        }
    }
}
