//
//  SwiftUIView.swift
//  
//
//  Created by Andreas Ink on 6/11/22.
//

import SwiftUI
import SFSafeSymbols

// Shows health requests 
public struct DataTypesListView: View {
    
    @State public var toggleData: [ToggleData]
    
    @State public var title: String
    
    @State public var caption: String
    
    @State public var showBtn: Bool
    
    @ObservedObject var vito: Vito
    public init(toggleData: [ToggleData], title: String, caption: String, showBtn: Bool = true, vito: Vito) {
        self.toggleData = toggleData
        self.title = title
        self.caption = caption
        self.showBtn = showBtn
        self.vito = vito
    }
    @StateObject var webViewModel = WebViewModel()
    public var body: some View {
        if vito.fitbit {
            
            WebView(webView: webViewModel.webView)
               
                .onAppear() {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
                        
                
                        vito.accessToken = webViewModel.webView.url?.absoluteString.replacingOccurrences(of: "https://andreasink.web.app/#access_token=", with: "").replacingOccurrences(of: " ", with: "").components(separatedBy: "&")[0]
                    print(vito.accessToken)
                    }
                                                  }
                    
                    
                
        
        } else {
            
        }
        VStack(alignment: .leading) {
            Spacer()
            
            if !title.isEmpty {
            Image(systemSymbol: .chartBar)
                .font(.system(size: 65, weight: .bold, design: .rounded))
                .foregroundColor(Color.accentColor)
                .padding(.leading)
                .padding(.vertical)
            
            Spacer()
            
            TextAnimation(lettersArr: [Letter(letter: title, font: .system(size: 28, weight: .bold, design: .rounded), colors: [.blue, .blue.opacity(0.95)]), Letter(letter: caption, font:  .system(size: 18, weight: .semibold, design: .rounded), colors: [.black.opacity(0.9)])], speed: 2.0, spacing: 2, isLeading: true)
            
                .padding(.bottom)
            }
            VStack(alignment: .leading) {
                
                ForEach(toggleData.indices, id:\.self) { i in
                    Button(action: {
                        withAnimation(.beat) {
                            if !(toggleData[i].toggle) {
                                toggleData[i].toggle = true
                            } else {
                                toggleData[i].toggle = false
                            }
                        }
                    }) {
                        VStack {
                            HStack {
                                
                                Image(systemSymbol: toggleData[i].explanation.image)
                                    .font(.title.bold())
                                    .frame(width: 75)
                                
                                if !toggleData[i].explanation.explanation.isEmpty {
                                    Text(toggleData[i].explanation.explanation)
                                        .multilineTextAlignment(.leading)
                                        .font(.system(.headline, design: .rounded))
                                        .foregroundColor(.black.opacity(0.9))
                                }
                                Spacer()
                            }
                            if (toggleData[i].toggle) {
                                HStack {
                                    
                                    Text(toggleData[i].explanation.detail)
                                        .font(.system(.body, design: .rounded))
                                    
                                        .fixedSize(horizontal: false, vertical: true)
                                        .foregroundColor(Color.blue.opacity(0.8))
                                        .padding(.top)
                                        .padding(.leading)
                                        .multilineTextAlignment(.leading)
                                    Spacer()
                                }
                            }
                        } .fixedSize(horizontal: false, vertical: true)
                        
                    } .padding(.top)
                    
                } .padding()
                Spacer()
                if showBtn {
                Button("APPROVE") {
                    Task {
                       
                        
                            var selectedTypes = [HealthType]()
                        
                            for i in toggleData.indices {
                                if toggleData[i].explanation.image == .bolt {
                                    selectedTypes.append(.Activity)
                                }
                                if toggleData[i].explanation.image == .figureWalk {
                                    //vito.selectedTypes.append(.Mobility)
                                    selectedTypes.append(.Mobility)
                                }
                                if toggleData[i].explanation.image == .heart {
                                    selectedTypes.append(.Vitals)
                                }
                            }
                           
                               
                                    print(selectedTypes)
                                    
                                    vito.auth(selectedTypes: selectedTypes)
                                    
                       
                           
                        
                                
                        
                    }
                } .buttonStyle(VitoBtnStyle(icons: toggleData.map{$0.explanation.image}))
                    .padding(.vertical)
                } 
            }
        
        
    }
}
}
