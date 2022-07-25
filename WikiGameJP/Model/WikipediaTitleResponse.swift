import Foundation

struct WikipediaTitleResponse: Decodable, Equatable {
    var query: WikipediaQuery
}

struct WikipediaQuery: Decodable, Equatable {
    var random: [WikipediaTitle]
}

struct WikipediaTitle: Decodable, Equatable {
    var id: Int
    var title: String
}


//{
//  "batchcomplete": "",
//  "continue": {
//    "rncontinue": "0.690578826146|0.690582364492|4327842|0",
//    "continue": "-||"
//  },
//  "query": {
//    "random": [
//      {
//        "id": 1,
//        "ns": 0,
//        "title": "test-title-1"
//      },
//      {
//        "id": 2,
//        "ns": 0,
//        "title": "test-title-2"
//      }
//    ]
//  }
//}
