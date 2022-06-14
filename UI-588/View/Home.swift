//
//  Home.swift
//  UI-588
//
//  Created by nyannyan0328 on 2022/06/14.
//

import SwiftUI
import Charts

struct Home: View {
    @Environment(\.self) var env
    @State var currentValue : String = "7 Days"
    @State var sampleAnalystics : [SliteView] = sample_analytics
    @State var currentActiveItem : SliteView?
    @State var isLineGraph : Bool = false
    
    @State var plotWidth : CGFloat = 0
    var body: some View {
      
            
            VStack{
                
                VStack(alignment: .leading,spacing: 8){
                    
                    
                    HStack{
                        
                          Text("Views")
                            .font(.title3)
                        
                        Picker("", selection: $currentValue) {
                            
                            Text("7 Days")
                                .tag("7 Days")
                            
                            Text("Week")
                                .tag("Week")
                            
                            Text("Month")
                                .tag("Month")
                            
                        }
                        .pickerStyle(.segmented)
                        .padding(.leading,80)
                    }
                    
                    let todayValue = sampleAnalystics.reduce((0.0)) { partialResult, item in
                        
                        
                        item.views + partialResult
                    }
                    
                    Text(todayValue.stringFormat)
                        .font(.largeTitle)
                    
                    
                }
//                .background{
//
//                    RoundedRectangle(cornerRadius: 10,style: .continuous)
//                        .fill(.white.shadow(.drop(radius: 10)))
//                }
                
                
                ChartView()
                
                Toggle("Line Graph", isOn: $isLineGraph)
                
                
                
            }
            .padding()
            .frame(maxWidth: .infinity, maxHeight: .infinity,alignment: .top)
            .navigationTitle("Swift Chart")
            .onChange(of: currentValue) { newValue in
                
                if newValue != "7 Days"{
                    sampleAnalystics = sample_analytics
                    
                    for (index, _) in sampleAnalystics.enumerated(){
                        
                        sampleAnalystics[index].views = .random(in: 1500...10000)
                    }
                    
                    
                }
                
                animtedGraph(fromChange: true)
            }
        
    }
    @ViewBuilder
    func ChartView()->some View{
        
        let max = sampleAnalystics.max { item1, item2 in
            
            return item2.views > item1.views
        }?.views ?? 0
        
        Chart{
            
            ForEach(sampleAnalystics){item in
                
                
                if isLineGraph{
                    
                    LineMark(
                    
                        x:.value("Hour", item.hour,unit: .hour),
                        y:.value("Views", item.animated ?  item.views : 0)
                    
                    
                    )
                    .foregroundStyle(Color("Blue").gradient)
                    .interpolationMethod(.catmullRom)
                    
                }
                else{
                    
                    BarMark(
                    
                        x:.value("Hour", item.hour,unit: .hour),
                        y:.value("Views", item.animated ?  item.views : 0)
                    
                    
                    )
                    .foregroundStyle(Color("Blue").gradient)
                    .interpolationMethod(.catmullRom)
                }
                
                if isLineGraph{
                    
                     AreaMark(
                    
                        x:.value("Hour", item.hour,unit: .hour),
                        y:.value("Views", item.animated ?  item.views : 0)
                    
                    
                    )
                     .foregroundStyle(Color("Blue").opacity(0.3) .gradient)
                    .interpolationMethod(.catmullRom)
                }
                
                
                if let currentActiveItem,currentActiveItem.id == item.id{
                    
                    
                    RuleMark(x:.value("Hour", currentActiveItem.hour))
                        .lineStyle(.init(lineWidth: 2,dash:[2],dashPhase:2))
                        .offset(x:(plotWidth / CGFloat(sampleAnalystics.count)) / 2)
                        .annotation(position: .top) {
                            
                            
                            VStack(alignment: .leading, spacing: 15) {
                                
                                
                                Text("Views")
                                    .font(.caption.bold())
                                
                                Text(currentActiveItem.views.stringFormat)
                                    .font(.title3.bold())
                                
                            }
                            .padding(.vertical,10)
                            .padding(.horizontal)
                            .background{
                             
                                RoundedRectangle(cornerRadius: 10,style:.continuous)
                                    .fill(.white.shadow(.drop(radius: 10)))
                            }
                        }
                    
                }
            
                
            }
            
        }
        .chartOverlay(content: { proxy in
            
            
            GeometryReader{innnerProxy in
                
                Rectangle()
                    .fill(.clear)
                    .contentShape(Rectangle())
                    .gesture(
                    
                    DragGesture()
                        .onChanged{value in
                            
                            let location = value.location
                            
                            if let data : Date = proxy.value(atX: location.x){
                                
                                
                                let calendar = Calendar.current
                                
                                let hour = calendar.component(.hour, from: data)
                                
                                
                                if let currentActiveItem = sampleAnalystics.first(where: { item in
                                    
                                    calendar.component(.hour, from: item.hour) == hour
                                }){
                                    self.currentActiveItem = currentActiveItem
                                    self.plotWidth = proxy.plotAreaSize.width
                                    
                                    
                                }
                                
                            }
                            
                            
                        }
                        .onEnded{value in
                            
                            self.currentActiveItem = nil
                            
                        }
                    
                    )
                
            }
        })
        .frame(height:250)
        .chartYScale(domain: 0...(max + 5000))
        .onAppear{
            
            animtedGraph()
        }
        
        
    }
    func animtedGraph(fromChange : Bool = false){
        
        for (index,_) in sampleAnalystics.enumerated(){
            
            DispatchQueue.main.asyncAfter(deadline: .now() + Double(index) * (fromChange ? 0.03 : 0.05)) {
                
                
                withAnimation(fromChange ? .easeOut(duration: 0.8) : .interactiveSpring(response: 0.8,dampingFraction: 0.8,blendDuration: 0.8)){
                    
                    sampleAnalystics[index].animated = true
                }
                
            }
        }
    }
}

struct Home_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

extension Double{
    
    var stringFormat : String{
        
        
        if self >= 10000 && self < 1000000{
            
            return String(format: "%.1fk", locale: Locale.current,self / 10000).replacingOccurrences(of: ".0f", with: "")
        }
        
        if self > 999999{
            
            
            return String(format: "%.1m", locale: Locale.current, self / 1000000).replacingOccurrences(of: ".0f", with: "")
            
        }
        
        return String(format: "%.0f", locale: Locale.current,self)
        
    }
}
