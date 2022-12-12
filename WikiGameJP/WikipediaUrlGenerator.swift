import Foundation

protocol WikipediaUrlGenerator {
    func generateGetTitleUrl() -> String
    func generateGetPageInfoUrl(title: String) -> String
    func generateGetTitleInfoUrl(startTitle: String, goalTitle: String) -> String
}

class WikipediaUrlGeneratorImpl: WikipediaUrlGenerator {
    private let basePath = "https://ja.wikipedia.org/w/api.php"

    func generateGetTitleUrl() -> String {
        let query = "?action=query&format=json&list=random&rnnamespace=0&rnlimit=2"
        
        var url = basePath
        url.append(query)
        
        return url
    }
    
    func generateGetPageInfoUrl(title: String) -> String {
        let query = "?format=json&action=query&prop=revisions&rvprop=content&rvparse=1&titles="
        
        var url = basePath
        url.append(query)
        url.append(title.urlEncoded)
        url.append("&redirects")
        
        return url
    }
    
    func generateGetTitleInfoUrl(startTitle: String, goalTitle: String) -> String {
        let query = "?action=query&format=json&titles="
        
        var url = basePath
        url.append(query)
        url.append(startTitle.urlEncoded)
        url.append("%7C")
        url.append(goalTitle.urlEncoded)
        
        return url
    }
}

extension String {
    
    var urlEncoded: String {
        // 半角英数字 + "/?-._~" のキャラクタセットを定義
        let charset = CharacterSet.alphanumerics.union(.init(charactersIn: "/?-._~"))
        // 一度すべてのパーセントエンコードを除去(URLデコード)
        let removed = removingPercentEncoding ?? self
        // あらためてパーセントエンコードして返す
        return removed.addingPercentEncoding(withAllowedCharacters: charset) ?? removed
    }
}
