//
//  HomeView.swift
//  PublisherSubscriber
//
//  Created by Thongchai Subsaidee on 18/6/2564 BE.
//

import SwiftUI

struct HomeView: View {
    
    @StateObject var userVM = UserViewModel()
    
    var body: some View {
        VStack {
            Text(userVM.time)
                .padding()
            
            List(userVM.users) { user in
                Text(user.name)
            }
            
            List(userVM.logins, id: \.id) { login in
                Text(login.username)
            }
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
