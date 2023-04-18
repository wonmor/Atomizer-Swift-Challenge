import SwiftUI

/**
    Developed by John Seong, 2023. A WWDC 2023 Swift Student Challenge Submission.

    Atomizer is a SwiftUI app that visualizes atomic orbitals and molecular orbitals.
    It features atomic orbitals in the form of electron density, and molecular orbitals in which you can view it in AR.
    ARKit and SceneKit are used to render the 3D models. Object occlusion is also supported, despite the fact that only RealityKit supports it.
    For the data, it uses the ElectronVisualized REST API created from scratch by myself, using Python and Flask.

    I used ASE and GPAW to get electron density data, using Density Functional Theory (DFT).
    For the molecular orbitals, I used PySCF to get the molecular orbitals, using Hartree–Fock (HF) theory.

    For atomic orbitals, I used the spherical harmonics to compute the radial part of the atomic orbitals.
    Then, I sampled the wavefunction by using the Metropolis-Hastings algorithm.

    GitHub repo of the API that I created:
    https://github.com/wonmor/ElectronVisualized

    Relevant links:
    https://en.wikipedia.org/wiki/Spherical_harmonics
    https://en.wikipedia.org/wiki/Metropolis–Hastings_algorithm
    https://en.wikipedia.org/wiki/Density_functional_theory
    https://en.wikipedia.org/wiki/Hartree%E2%80%93Fock_method
 
    1) I additionally referenced two open source projects from GitHub, first of which being Microbit.swift written by Peter Wallen.
    As it is my first time working on an embedded system, and as a person who is not familiar with Bluetooth LE technology,
    an external library solution for the communication between micro:bit controller and iOS device was a necessary choice.
    https://github.com/phwallen/microbit-swift
 
    2) The second open source resource I utilized was LiquidSwipe, featuring a beatiful "liquid swipe" type control as the name suggests.
    https://github.com/exyte/LiquidSwipe
*/

@main
struct MyApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
                .preferredColorScheme(.dark) // Forces the app to be in dark mode only cause it looks better
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .preferredColorScheme(.dark)
    }
}
