import UIKit
import WebKit
import KRProgressHUD

class DetailViewController: UIViewController {
  
  var webView: WKWebView!
  var githubUser: GithubUserViewModel?
  override func viewDidLoad() {
      super.viewDidLoad()
    webView = WKWebView()
    webView.navigationDelegate = self
    view = webView
    loadWebView()
  }
  
  func loadWebView() {
    guard let githubUser = githubUser else {
      return
    }
    
    self.navigationItem.title = githubUser.loginName
    
    guard let url = URL(string: githubUser.githubURL) else {
      return
    }
    
    KRProgressHUD.show()
    webView.load(URLRequest(url: url))
  }
}

extension DetailViewController: WKNavigationDelegate {

  func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
    KRProgressHUD.dismiss()
  }
}

