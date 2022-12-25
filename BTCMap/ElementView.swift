//
//  SwiftUIView.swift
//  BTCMap
//
//  Created by salva on 12/23/22.
//

import SwiftUI

struct ElementView: View {
    @Environment(\.openURL) var openURL
    @State private var showingOptions = false
    
    let elementViewModel: ElementViewModel
    
    var body: some View {
        VStack(alignment: .leading) {
            
            // MARK: - Title, Options Button
            HStack {
                Text(elementViewModel.element.osmJson.tags?["name"] ?? "")
                    .font(.title)
                    .padding()
                Spacer()
                Button(action: {
                    showingOptions = true
                }) {
                    Image(systemName: "ellipsis")
                }
                .confirmationDialog("Options", isPresented: $showingOptions, titleVisibility: .hidden) {
                    Button("supertagger_manual".localized) {
                        openURL(elementViewModel.superTaggerManualLink)
                    }
                    
                    if let url = elementViewModel.viewOnOSMLink {
                        Button("view_on_osm".localized) {
                            openURL(url)
                        }
                    }
                  
                    if let url = elementViewModel.ediotOnOSMLink {
                        Button("edit_on_osm".localized) {
                            openURL(url)
                        }
                    }
                }
            }
            
            // MARK: - Verified
            HStack {
                // TODO: Add logic - verified
                HStack {
                    Image(systemName: "checkmark.seal.fill")
                    Text("not_verified_by_supertaggers".localized)
                        .font(.subheadline)
                }
                Spacer()
                Button(action: {
                    if let url = elementViewModel.verifyLink {
                        openURL(url)
                    }
                }) {
                    Text("verify".localized.uppercased())
                }
                .buttonStyle(BorderButtonStyle(foregroundColor: Color.BTCMap_Green, strokeColor: Color.gray.opacity(0.5), padding: EdgeInsets(top: 8, leading: 16, bottom: 8, trailing: 16)))
            }
            .padding(.bottom, 18)
            .padding(.horizontal)
            
            
            // MARK: - Details
            let details = elementViewModel.elementDetails
            if !details.isEmpty {
                ForEach(details, id: \.0) { detail in
                    VStack(alignment: .leading) {
                        HStack {
                            Image(systemName: detail.type.displayIconSystemName)
                            Text(detail.type.displayTitle)
                                .font(.headline)
                        }
                        .padding(.bottom, 0)
                         
                        let url: URL? = {
                            switch detail.type {
                            case .phone:
                                // TODO: phone url not resolving
                                let _ = print("[LINK] phone: \(detail.value)")
                                return URL(string: "tel:\(detail.value)")
                            case .website:
                                let _ = print("[LINK] website: \(detail.value)")
                                return URL(string: "\(detail.value)")
                            case .email:
                                let _ = print("[LINK] email: \(detail.value)")
                                return URL(string: "mailto:\(detail.value)")
                            default: return nil
                            }
                        }()
                        
                        let _ = print("[LINK] url: \(url)")
                            
                        if let url = url {
                            Link("\(detail.value)", destination: url)
                        } else {
                            Text(detail.value)
                                .font(.subheadline)
                        }
                     
                    }
                    .padding(.bottom, 10)
                    .padding(.horizontal)
                }
            }
        }
        .padding()
        .alignmentGuide(.top) { _ in 0 }
        
        Spacer()
    }
}

struct ElementView_Previews: PreviewProvider {
    static var previews: some View {
        ElementView(elementViewModel: ElementViewModel(element: API.Element.mock! ))
    }
}
