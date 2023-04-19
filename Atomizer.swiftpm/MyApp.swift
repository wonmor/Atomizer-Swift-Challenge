import SwiftUI

/**
    ATOMIZER: Visualizing Quantum Mechanics.
    Developed by John Seong, 2023. A WWDC 2023 Swift Student Challenge Submission.
    Built using Xcode 14 on macOS Ventura, designed to run on iPhone, iPad, and ARM-based Macs.

    Atomizer is a state-of-the-art SwiftUI app that visualizes atomic and molecular orbitals.
    It features atomic orbitals in the form of electron density, and molecular orbitals in which you can view it in AR.
 
    - ARKit and SceneKit are used to render the 3D models. Object occlusion is also supported on LiDAR-enabled devices.
 
    - Using Apple's powerful ML-trained Vision framework, I was able to achieve object spawning by hand detection,
    in which the molecule will come right into your hand like Thor's hammer, all in Augmented Reality.
 
    - For the electron coordinate data, it uses the ElectronVisualized API I created from scratch by myself, using Python and Flask.
 
    Target audience:
    High school/Undergraduate students, computational chemists, or anyone who's interested in learning more about quantum mechanics.
 
    Disclaimer:
    DON'T WORRY, INTERNET CONNECTION IS *NOT* REQUIRED TO RUN THIS APP.
    I PRE-LOADED ALL THE 3D ASSETS FOR PLOTTING.

    - I used ASE and GPAW to get electron density data, using Density Functional Theory (DFT).
    For the molecular orbitals, I used PySCF to get the molecular orbitals, using Hartree–Fock (HF) theory.

    - For atomic orbitals, I used the spherical harmonics to compute the radial part of the atomic orbitals.
    Then, I sampled the wavefunction by using the Metropolis-Hastings algorithm.

    GitHub repo of the ElectronVisualized API that I created:
    https://github.com/wonmor/ElectronVisualized

    Relevant links:
    https://en.wikipedia.org/wiki/Spherical_harmonics
    https://en.wikipedia.org/wiki/Metropolis–Hastings_algorithm
    https://en.wikipedia.org/wiki/Density_functional_theory
    https://en.wikipedia.org/wiki/Hartree%E2%80%93Fock_method
 
    Warm regards,
 
    John Seong
    Class of 2023 at Garth Webb Secondary School
    Oakville, Canada
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
