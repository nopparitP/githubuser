import Foundation

enum Result<T> {
  case success(T)
  case failure
}

enum Content<T> {
  case success(T)
  case failure
  case loading
}

enum FetchType {
  case refresh
  case loadmore
}

struct GithubUser: Codable {
    let login: String
    let avatarURL: String
    let htmlURL: String
    let type: String
    let siteAdmin: Bool
    var isFavourite: Bool

    enum CodingKeys: String, CodingKey {
        case login
        case avatarURL = "avatar_url"
        case htmlURL = "html_url"
        case type
        case siteAdmin = "site_admin"
        case isFavourite
    }
  
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.login = try container.decodeIfPresent(String.self, forKey: .login) ?? ""
        self.avatarURL = try container.decodeIfPresent(String.self, forKey: .avatarURL) ?? ""
        self.htmlURL = try container.decodeIfPresent(String.self, forKey: .htmlURL) ?? ""
        self.type = try container.decodeIfPresent(String.self, forKey: .type) ?? ""
        self.siteAdmin = try container.decodeIfPresent(Bool.self, forKey: .siteAdmin) ?? false
        self.isFavourite = try container.decodeIfPresent(Bool.self, forKey: .isFavourite) ?? false
    }
}


public struct GithubUserViewModel {
  let loginName: String
  let avatarURL: String
  let githubURL: String
  let accountType: String
  let siteAdmin: Bool
  let isFavourite: Bool
}

