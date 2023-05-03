<img width="100" alt="icon-2" src="https://user-images.githubusercontent.com/35755386/235810046-56828de6-5edf-4000-a3cb-d1bfc94b91b1.png">

# Atomizer AR

> **Visualizing Quantum Mechanics, Reimagined.**

Developed by John Seong, 2023. A WWDC 2023 Swift Student Challenge Submission.
Built using Xcode 14 on macOS Ventura, designed to run on iPhone, iPad, and ARM-based Macs.

---

![IMG_4585-2](https://user-images.githubusercontent.com/35755386/235809592-378717d7-3747-4c9f-8c62-a81d0e17df47.jpg)

---

Atomizer is a state-of-the-art SwiftUI app that visualizes atomic and molecular orbitals.
It features atomic orbitals in the form of electron density, and molecular orbitals in which you can view it in AR.

- ARKit and SceneKit are used to render the 3D models. Object occlusion is also supported on LiDAR-enabled devices.

- Using Apple's powerful ML-trained Vision framework, I was able to achieve object spawning by hand detection,
in which the molecule will come right into your hand like Thor's hammer, all in Augmented Reality.

- For the electron coordinate data, it uses the ElectronVisualized API I created from scratch by myself, using Python and Flask.

---

![IMG_1218](https://user-images.githubusercontent.com/35755386/235810213-0502e4d9-2e62-490b-b271-a6923d2e3042.jpg)

---
> *Watch the Demo: https://www.youtube.com/watch?v=kHcdvyaqslU*
> 
> GitHub repo of the ElectronVisualized API that I created:
> https://github.com/wonmor/ElectronVisualized

- I used ASE and GPAW to get electron density data, using Density Functional Theory (DFT).
For the molecular orbitals, I used PySCF to get the molecular orbitals, using Hartree–Fock (HF) theory.

- For atomic orbitals, I used the spherical harmonics to compute the radial part of the atomic orbitals.
Then, I sampled the wavefunction by using the Metropolis-Hastings algorithm.
