//
//  DetailViewController.swift
//  MyMovieChart
//
//  Created by 김희진 on 2022/05/01.
//

import Foundation
import WebKit

class DetailViewController: UIViewController {
   
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    @IBOutlet var wv: WKWebView!
    var mvo: MovieVO! // 이전 화면에서 데이터를 넘겨 받을 객체 변수

    override func viewDidLoad() {
        NSLog("\(mvo.detail)")
        
        let navibar = self.navigationItem
        navibar.title = mvo?.title
 
        wv.navigationDelegate = self
//        wv.uiDelegate = self
        
        if let url = self.mvo.detail {
            if let urlObj = URL(string: url) {
                let req = URLRequest(url: urlObj)
                wv.load(req)
            }else {
                let alert = UIAlertController(title: "오류", message: "잘못된 URL입니다", preferredStyle: .alert)
                
                let cancelAction = UIAlertAction(title: "확인", style: .cancel) { _ in
                    _ = self.navigationController?.popViewController(animated: true)
                }
                
                alert.addAction(cancelAction)
                self.present(alert, animated: true, completion: nil)
            }
        }else {
            let alert = UIAlertController(title: "오류", message: "필수 파라미터가 누락되었습니다", preferredStyle: .alert)
            
            let cancelAction = UIAlertAction(title: "확인", style: .cancel) { _ in
                _ = self.navigationController?.popViewController(animated: true)
            }
            
            alert.addAction(cancelAction)
            self.present(alert, animated: true, completion: nil)
        }
        
        let url = URL(string: self.mvo.detail ?? "")
        let req = URLRequest(url: url!)
        
        self.wv.load(req)
    }

}

extension DetailViewController: WKNavigationDelegate {
    func webView(_ webView: WKWebView, didCommit navigation: WKNavigation!) {
        spinner.startAnimating()
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        spinner.stopAnimating() // Hides When Stopped 속성을 체크했기 때문에 애니메이션을 중지만 하면 사라진다!
    }
    
    // 도중 읽어오기 실패
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        spinner.stopAnimating()
        
        self.alert("상세 페이지를 읽어오지 못했습니다") {
            _ = self.navigationController?.popViewController(animated: true)
        }
    }
    
    // 네트워크 문제, 잘못된 url
    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
        spinner.stopAnimating()
        
        self.alert("상세 페이지를 읽어오지 못했습니다") {
            _ = self.navigationController?.popViewController(animated: true)
        }
    }
}

extension UIViewController {
    func alert(_ message: String, onClick: (() -> Void)? = nil) {

        let controller = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        
        controller.addAction( UIAlertAction(title: "확인", style: .cancel) { _ in
            onClick?()
        })
        
        DispatchQueue.main.async {
            self.present(controller, animated: false)
        }
    }
}
