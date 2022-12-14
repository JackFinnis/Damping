//
//  RootView.swift
//  Damping
//
//  Created by Jack Finnis on 30/11/2021.
//

import SwiftUI

struct RootView: View {
    @StateObject var vm = ViewModel()
    @State var editing = false
    let clock = Timer.publish(every: 0.01, on: .main, in: .common).autoconnect()
    
    var body: some View {
        VStack(spacing: 0) {
            GeometryReader { geo in
                Circle()
                    .frame(width: 20)
                    .foregroundColor(.accentColor)
                    .position(x: geo.size.width / 2, y: editing ? geo.size.height : geo.size.height * (vm.y.real / 4 + 0.5))
            }
            .background(Color(.systemFill))
            .gesture(DragGesture(minimumDistance: 0)
                .onChanged { _ in
                    editing = true
                }
                .onEnded { _ in
                    editing = false
                    vm.reset()
                }
            )
            
            VStack(alignment: .leading) {
                Text(vm.type.rawValue)
                    .font(.headline)
                    .animation(.none)
                VStack(spacing: 3) {
                    SliderRow(editing: $editing, value: $vm.m, name: "Mass") { vm.m = pow(vm.c, 2)/(4*vm.k) }
                    SliderRow(editing: $editing, value: $vm.k, name: "Stiffness") { vm.k = pow(vm.c, 2)/(4*vm.m) }
                    SliderRow(editing: $editing, value: $vm.c, name: "Damping") { vm.c = sqrt(4*vm.k*vm.m) }
                }
            }
            .padding(.horizontal)
            .padding(.vertical, 10)
        }
        .environmentObject(vm)
        .onReceive(clock) { _ in
            vm.t += 0.1
        }
    }
}

struct SliderRow: View {
    @EnvironmentObject var vm: ViewModel
    
    @Binding var editing: Bool
    @Binding var value: Double
    let name: String
    let tapped: () -> Void
    
    var body: some View {
        HStack {
            Text(name)
                .frame(width: 70, alignment: .trailing)
                .onTapGesture {
                    withAnimation {
                        tapped()
                    }
                    vm.reset()
                }
            Slider(value: $value, in: 1...100, step: 1) { editing in
                self.editing = editing
                vm.reset()
            }
        }
    }
}
