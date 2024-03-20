//
//  MainTabBar.swift
//  TinderClone
//
//  Created by Marco Alonso on 12/03/24.
//

import SwiftUI

struct MainTabView: View {
    var body: some View {
        
        TabView {
            CharactersView()
                .tabItem { Image(systemName: "square.grid.3x1.below.line.grid.1x2") }
                .tag(0)
            
            Text("Planets")
                .tabItem { Image(systemName: "magnifyingglass") }
                .tag(1)
            
            
            Text("Profile View")
                .tabItem { Image(systemName: "person") }
                .tag(2)
        }
        .tint(.primary)
    }
}

#Preview {
    MainTabView()
}
