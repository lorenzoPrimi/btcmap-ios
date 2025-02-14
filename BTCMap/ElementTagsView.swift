//
//  ElementTagsView.swift
//  BTCMap
//
//  Created by salva on 1/21/23.
//

import SwiftUI

struct ElementTagsView: View {
    @Environment(\.openURL) var openURL
    let elementViewModel: ElementViewModel
    
    var body: some View {
        VStack(alignment: .leading, spacing: 15) {
            let details = elementViewModel.elementDetails
            if !details.isEmpty {
                ForEach(details, id: \.0) { detail in
                    HStack {
                        if let systemName = detail.type.displayIconSystemName {
                            Image(systemName: systemName).renderingMode(.template).colorMultiply(.BTCMap_LightBeige)
                        } else if let customName = detail.type.displayIconCustomName {
                            Image(customName).renderingMode(.template).colorMultiply(.BTCMap_LightBeige)
                        }
                                                
                        let url: URL? = {
                            switch detail.type {
                            case .phone:
                                // TODO: phone url not resolving with some formats
                                return URL(string: "tel:\(detail.value)")
                            case .website:
                                return URL(string: "\(detail.value)")
                            case .email:
                                return URL(string: "mailto:\(detail.value)")
                            default: return nil
                            }
                        }()
                        
                        if let url = url {
                            Button(action: {
                                UIApplication.shared.open(url)
                            }) {
                                Link("\(detail.title)", destination: url)
                                    .foregroundColor(Color.BTCMap_DarkBeige)
                                    .font(.system(size: 18, weight: .black))
                            }
                        } else {
                            Text(detail.value)
                                .font(.system(size: 18, weight: .black))
                        }
                    }
                }
            }
            
            // MARK: - Tags Dump
            if let tags = elementViewModel.element.osmJson.tags {
                VStack(alignment: .leading, spacing: 10) {
                    HStack {
                        Image(systemName: "list.bullet.circle.fill").renderingMode(.template).colorMultiply(.BTCMap_LightBeige)
                        Text("tags".localized)
                            .fontWeight(.bold)
                            .font(.subheadline)
                    }
                    ForEach(Array(tags.keys), id: \.self) { key in
                        HStack {
                            if let value = tags[key]{
                                Text("\(key)")
                                    .fontWeight(.bold)
                                    .font(.system(size: 12))
                                    .foregroundColor(.gray)
                                Text(value)
                                    .font(.system(size: 12))
                                    .foregroundColor(Color.BTCMap_LightTeal)
                            }                          
                        }
                      
                    }

                }
                .padding(.top, 30)
            }
        }
    }
}

//struct ElementTagsView_Previews: PreviewProvider {
//    static var previews: some View {
//        ElementTagsView()
//    }
//}
