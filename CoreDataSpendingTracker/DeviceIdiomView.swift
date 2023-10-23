//
//  DeviceIdiomView.swift
//  CoreDataSpendingTracker
//
//  Created by joe on 2023/10/23.
//

import SwiftUI

struct DeviceIdiomView: View {
    @Environment(\.horizontalSizeClass) var horizontalSizeClass
    
    var body: some View {
        if UIDevice.current.userInterfaceIdiom == .phone {
            MainView()
        } else {
            if horizontalSizeClass == .compact {
                Color.blue
            } else {
                MainPadDeviceView()
            }
        }
    }
}

struct DeviceIdiomView_Previews: PreviewProvider {
    static var previews: some View {
        DeviceIdiomView()
        
        DeviceIdiomView()
            .previewDevice(PreviewDevice(rawValue: "iPad Pro (11-inch) (4th generation)"))
            .environment(\.horizontalSizeClass, .regular)
            .previewInterfaceOrientation(.landscapeLeft)
        
        DeviceIdiomView()
            .previewDevice(PreviewDevice(rawValue: "iPad Pro (11-inch) (4th generation)"))
            .environment(\.horizontalSizeClass, .compact)
    }
}
