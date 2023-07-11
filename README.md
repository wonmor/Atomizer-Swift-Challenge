<img width="100" alt="icon-2" src="https://user-images.githubusercontent.com/35755386/235810046-56828de6-5edf-4000-a3cb-d1bfc94b91b1.png">

# Atomizer AR

> **This public archive was not intended for use in production. Please read the license carefully before using any parts or segments of this source code.**

Developed by John Seong, 2023. A WWDC23 Swift Student Challenge Submission.
Built using Xcode 14 on macOS Ventura, designed to run on iPhone, iPad, and ARM-based Macs.

| iOS, iPadOS, and macOS |
|:-:|
| [<img src="Docs/appstore-badge.png" height="50">](https://apps.apple.com/us/app/atomizer-ar/id6449015706) |

---

![346091630_962156048139650_5797215412402448016_n](https://github.com/wonmor/wonmor/assets/35755386/b606d6ee-5c5a-482a-8c6e-b66be7aebad2)

---

Atomizer is a state-of-the-art SwiftUI app that visualizes atomic and molecular orbitals.
It features atomic orbitals in the form of electron density, and molecular orbitals in which you can view it in AR.

- ARKit and SceneKit are used to render the 3D models. Object occlusion is also supported on LiDAR-enabled devices.

- Using Apple's powerful ML-trained Vision framework, I was able to achieve object spawning by hand detection,
in which the molecule will come right into your hand like Thor's hammer, all in Augmented Reality.

- For the electron coordinate data, it uses the ElectronVisualized API I created from scratch by myself, using Python and Flask.

---

> *Watch the Demo: https://www.youtube.com/watch?v=kHcdvyaqslU*
> 
> GitHub repo of the **ElectronVisualized API** that I created:
> https://github.com/wonmor/ElectronVisualized

- I used ASE and GPAW to get electron density data, using Density Functional Theory (DFT).
For the molecular orbitals, I used PySCF to get the molecular orbitals, using Hartree–Fock (HF) theory.

- For atomic orbitals, I used the spherical harmonics to compute the radial part of the atomic orbitals.
Then, I sampled the wavefunction by using the Metropolis-Hastings algorithm.
