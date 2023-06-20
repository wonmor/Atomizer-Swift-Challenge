<img width="100" alt="icon-2" src="https://user-images.githubusercontent.com/35755386/235810046-56828de6-5edf-4000-a3cb-d1bfc94b91b1.png">

# Atomizer AR

> **Visualizing Quantum Mechanics, Reimagined.**

Developed by John Seong, 2023. A WWDC23 Swift Student Challenge Submission.
Built using Xcode 14 on macOS Ventura, designed to run on iPhone, iPad, and ARM-based Macs.

---

<table><tr>

<td valign="center"><img width="200" alt="Screenshot-1" src="https://github.com/wonmor/wonmor/assets/35755386/d579ca34-5b00-48dc-9f85-6499ec1c1ce5"></td>

<td valign="center"><img width="200" alt="Screenshot-2" src="https://github.com/wonmor/wonmor/assets/35755386/40cf5a27-95cb-4d44-bc2a-bdf5a934e241"></td>
  
  <td valign="center"><img width="200" alt="Screenshot-3" src="https://github.com/wonmor/wonmor/assets/35755386/3e8890a1-e14c-4cb0-84bb-686339c590b0"></td>
  
  <td valign="center"><img width="200" alt="Screenshot-4" src="https://github.com/wonmor/wonmor/assets/35755386/6ff53efb-ea4c-462f-80de-b9b6157ea7f5"></td>
  
  <td valign="center"><img width="200" alt="Screenshot-5" src="https://github.com/wonmor/wonmor/assets/35755386/a2c4b9f8-9690-4460-b576-beb427763ab0"></td>
  
  <td valign="center"><img width="200" alt="Screenshot-6" src="https://github.com/wonmor/wonmor/assets/35755386/440ff984-0c2a-4b0b-89b5-68fe6d81fbbf"></td>

</tr></table>

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
