import Foundation

struct JikanPagination: Decodable {
    
    private(set) var currentPage: Int
    private(set) var lastVisiblePage: Int
    private(set) var hasNextPage: Bool
    private(set) var items: JikanPaginationData
}

struct JikanPaginationData: Decodable {
    
    private(set) var perPage: Int
    private(set) var count: Int
    private(set) var total: Int
}
