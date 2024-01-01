//
//  ContentView.swift
//  testFDJ_LIMAM
//
//  Created by Belhassen LIMAM on 31/12/2023.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject var viewModel = HomeViewModel(getLeaguesServices: LeaguesService(), getTeamsServices: TeamsService())
    @State private var listTeams = [League]()
    @State private var searchText = ""
    var columns: [GridItem] = [
            GridItem(.flexible()),
            GridItem(.flexible()),
        ]
    
    func teamSections (_ listTeams: [League]) -> some View {
        VStack(spacing: .zero) {
            ForEach(listTeams, id: \.idLeague) { league in
                VStack {
                    Text(league.strLeague)
                    Divider()
                }
            }
        }
    }
    func teamCards (_ listTeams: [Team]) -> some View {
            ForEach(listTeams, id: \.idTeam) { team in
                    let url = URL(string:team.strTeamBadge ?? "")!
                    AsyncImage(url: url, placeholder: { Text("Loading ...") })
                        .scaledToFit()
                        .onTapGesture {
                            print(team.idTeam!)
                        }
            }
    }
    
    var body: some View {

        NavigationView{
            ScrollView {
                LazyVGrid(columns: columns, spacing: 40) {
                    if !viewModel.listOfTeams.isEmpty {
                        self.teamCards(viewModel.listOfTeams)
                            
                    }
                }
                .padding(30)
            }
        }
        .onAppear{
            viewModel.fetchLeagues()
        }
        .searchable(text: $searchText) {
            ForEach(searchResults, id: \.self) { scope in
                Text("\(scope)").searchCompletion(scope)
            }
        }
        .onSubmit(of: .search, runSearch)
        
        var searchResults: [String] {
            if searchText.isEmpty {
                return viewModel.listLeaguesName
            } else {
                return viewModel.listLeaguesName.filter { $0.contains(searchText) }
            }
        }
    }
    
    func runSearch() {
        
        viewModel.fetchTeams(leagueName: searchText)
    }
}

#Preview {
    ContentView()
}
