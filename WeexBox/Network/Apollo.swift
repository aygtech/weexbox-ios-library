//
//  Apollo.swift
//  WeexBox
//
//  Created by Mario on 2019/1/29.
//  Copyright © 2019 Ayg. All rights reserved.
//

import Foundation
import Apollo

class AP {

    func aa() {
        let apollo = ApolloClient(url: URL(string: "http://localhost:8080/graphql")!)
        
        apollo.fetch(query: GraphQLQuery)
    }
}

class G: GraphQLQuery {
    typealias Data = <#type#>
    
    
}
