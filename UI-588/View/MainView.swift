//
//  MainView.swift
//  UI-588
//
//  Created by nyannyan0328 on 2022/06/14.
//

import SwiftUI

struct MainView: View {
    @State var mainStack : [navigationType] = []
    var body: some View {
        NavigationStack(path:$mainStack){
            
            TabView{
                
                Text("A")
                    .tabItem {
                        
                         Image(systemName: "house.fill")
                    }
                
                Text("B")
                    .tabItem {
                         Image(systemName: "magnifyingglass")
                    }
                
                Text("C")
                    .tabItem {
                        
                         Image(systemName: "suit.heart.fill")
                    }
                
                Text("C")
                    .tabItem {
                        
                         Image(systemName: "person.fill")
                    }
                
                
            }
            .navigationTitle("Bar Graph")
            .navigationDestination(for: navigationType.self) { value in
                
                
                switch value{
                    
                case .dm :
                    
                    VStack{
                        
                        
                        Button("Back"){
                            
                            mainStack.removeAll()
                        }
                        
                        
                        Button("Go to Home"){
                            
                            mainStack.append(.Graph)
                        }
                        
                    }
                    
                case .Graph : Home()
                    
                }
            }
            .toolbar {
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    
                    Button {
                        
                        mainStack.append(.dm)
                        
                    } label: {
                        
                         Image(systemName: "paperplane.fill")
                            .foregroundColor(.orange)
                    
                        
                    }

                }
                
                
                ToolbarItem(placement: .navigationBarLeading) {
                    
                    Button {
                        mainStack.append(.Graph)
                        
                    } label: {
                        
                        Image(systemName: "diamond.fill")
                            .foregroundColor(.black)
                        
                    }

                }
                
            }
            
        }
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

enum navigationType : String,Hashable{
    
    case dm  = "DM View"
    case Graph = "Graph View"
}

