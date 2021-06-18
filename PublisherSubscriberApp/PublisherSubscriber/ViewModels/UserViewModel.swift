//
//  UserViewModel.swift
//  PublisherSubscriber
//
//  Created by Thongchai Subsaidee on 18/6/2564 BE.
//

import SwiftUI
import Combine

class UserViewModel: ObservableObject {
    @Published var time = ""
    @Published var users: [UserModel] = []
//    @Published var logins: [LoginModel] = []
    @Published var logins: [UserLists] = []
    
    private var cancellables = Set<AnyCancellable>()
    
    //Stored properties
    let formatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.timeStyle = .medium
        return formatter
    }()
    
    init() {
        setupPublishers()
        setupDataTaskPublishers()
    }
    
    private func setupPublishers() {
        Timer.publish(every: 1, on: .main, in: .default)
            .autoconnect()
            .receive(on: RunLoop.main)
            .sink(receiveValue: { value in
                self.time = self.formatter.string(from: value)
                self.setupLoginDataTaskPublishers()
            })
            .store(in: &cancellables)
    }
    
    private func setupDataTaskPublishers() {
        
        let url = URL(string: "https://jsonplaceholder.typicode.com/users")!
        
        URLSession.shared.dataTaskPublisher(for: url)
            .tryMap { data, response in
                guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                    throw URLError(.badServerResponse)
                }
                return data
            }
            .decode(type: [UserModel].self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .sink { _ in } receiveValue: { users in
                self.users = users
            }
            .store(in: &cancellables)
    }
 
    
    private func setupLoginDataTaskPublishers() {
        let totken = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpdGVtcyI6W3sidXNlcm5hbWUiOiJyb2oiLCJwYXNzd29yZCI6IjEyMzQ1NiJ9XSwiaWF0IjoxNjIzOTg2ODY5fQ.Dt4_i-umcMzMDJX3OnULKgsCEr91dy7mLXNMY4FTk1A"
        let url = URL(string: "http://homenano.trueddns.com:24349/api/user")!
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.addValue("Bearer \(totken)", forHTTPHeaderField: "Authorization")
        
        URLSession.shared.dataTaskPublisher(for: request)
            .tryMap { data, response in
                guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                    throw URLError(.badServerResponse)
                }
                print("get login \(Date())")
                return data
            }
            .decode(type: [LoginModel].self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .sink { _ in} receiveValue: { logins in
                self.logins = logins.map(UserLists.init)
            }
            .store(in: &cancellables)
    }
}


struct UserLists {
    let user: LoginModel
    let id = UUID()
    
    var username: String {
        user.username
    }
    
    var password: String {
        user.password
    }
}
