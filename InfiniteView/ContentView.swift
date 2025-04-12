//
//  ContentView.swift
//  InfiniteView
//
//  Created by Balaji Venkatesh on 23/11/23.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        NavigationStack {
            Home()
                .navigationTitle("Looping ScrollView")
        }
    }
}

#Preview {
    ContentView()
}
