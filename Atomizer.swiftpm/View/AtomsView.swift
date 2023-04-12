import SwiftUI

struct AtomsView: View {
    @Environment(\.adaptiveSize) var adaptiveSize
    
    private var isIPad: Bool {
        return adaptiveSize.width >= 768
    }
    
    let elements = [
        (1, "H", "Hydrogen", "1s1", 1.008, 1, "The lightest and most abundant element in the universe, commonly used in fuel for rockets and as a component of water."),
        (2, "He", "Helium", "1s2", 4.003, 0, "A colorless, odorless, and tasteless gas, used for filling balloons and as a coolant in MRI machines."),
        (3, "Li", "Lithium", "[He] 2s1", 6.941, 1, "A soft, silvery-white metal that is highly reactive and flammable, commonly used in batteries."),
        (4, "Be", "Beryllium", "[He] 2s2", 9.012, 2, "A rare, hard, steel-gray metal that is lightweight and has a high melting point."),
        (5, "B", "Boron", "[He] 2s2 2p1", 10.81, 3, "A metalloid element that is used in fiberglass, ceramics, and as a dopant in semiconductors."),
        (6, "C", "Carbon", "[He] 2s2 2p2", 12.011, 4, "A nonmetal element that is the basis of life on Earth and has many allotropes, including diamond and graphite."),
        (7, "N", "Nitrogen", "[He] 2s2 2p3", 14.007, -3, "A nonmetal element that makes up 78% of Earth's atmosphere and is commonly used in fertilizer and as a refrigerant."),
        (8, "O", "Oxygen", "[He] 2s2 2p4", 15.999, -2, "A nonmetal element that makes up 21% of Earth's atmosphere and is essential for respiration in organisms."),
        (9, "F", "Fluorine", "[He] 2s2 2p5", 18.998, -1, "A highly reactive, corrosive, and toxic gas that is commonly used in toothpaste and as a refrigerant."),
        (10, "Ne", "Neon", "[He] 2s2 2p6", 20.18, 0, "A colorless, odorless, and inert gas that is used in advertising signs and as a coolant in cryogenics."),
        (11, "Na", "Sodium", "[Ne] 3s1", 22.99, 1, "A soft, silvery-white metal that is highly reactive and is a component of table salt."),
        (12, "Mg", "Magnesium", "[Ne] 3s2", 24.305, 2, "A light, silvery-white metal that is essential for many biological processes and is commonly used in alloys."),
        (13, "Al", "Aluminium", "[Ne] 3s2 3p1", 26.982, 3, "A lightweight, silvery-white metal that is the most abundant metal in the Earth's crust and is commonly used in packaging and construction."),
        (14, "Si", "Silicon", "[Ne] 3s2 3p2", 28.086, 4, "A metalloid element that is the second most abundant metal in the Earth's crust and is used in semiconductors, solar cells, and other electronic devices."),
        (15, "P", "Phosphorus", "[Ne] 3s2 3p3", 30.974, -3, "A nonmetal element that is essential for life and is used in fertilizers, detergents, and other products."),
        (16, "S", "Sulfur", "[Ne] 3s2 3p4", 32.06, -2, "A nonmetal element that is found in many minerals and is used in fertilizers, detergents, and other products."),
        (17, "Cl", "Chlorine", "[Ne] 3s2 3p5", 35.45, -1, "A highly reactive, corrosive, and toxic gas that is commonly used as a disinfectant and in the production of many chemicals."),
        (18, "Ar", "Argon", "[Ne] 3s2 3p6", 39.948, 0, "A colorless, odorless, and inert gas that is used in incandescent light bulbs and in welding."),
        (19, "K", "Potassium", "[Ar] 4s1", 39.098, 1, "A soft, silvery-white metal that is highly reactive and is a component of many minerals."),
        (20, "Ca", "Calcium", "[Ar] 4s2", 40.078, 2, "A soft, gray metal that is essential for many biological processes and is commonly used in construction materials."),
        (21, "Sc", "Scandium", "[Ar] 3d1 4s2", 44.956, 3, "A silvery-white metal that is used in high-strength alloys and in the production of some ceramics."),
        (22, "Ti", "Titanium", "[Ar] 3d2 4s2", 47.867, 4, "A strong, lightweight metal that is used in aircraft, armor, and medical implants."),
        (23, "V", "Vanadium", "[Ar] 3d3 4s2", 50.942, 5, "A hard, silvery-gray metal that is used in steel alloys and as a catalyst."),
        (24, "Cr", "Chromium", "[Ar] 3d5 4s1", 52.0, 6, "A hard, lustrous metal that is used in stainless steel and other alloys."),
        (25, "Mn", "Manganese", "[Ar] 3d5 4s2", 54.938, 7, "A hard, gray metal that is used in steel alloys and in the production of batteries."),
        (26, "Fe", "Iron", "[Ar] 3d6 4s2", 55.845, 2, "A strong, silvery-gray metal that is the most commonly used metal in the world."),
        (27, "Co", "Cobalt", "[Ar] 3d7 4s2", 58.933, 3, "A hard, lustrous metal that is used in alloys for jet engines and turbines."),
        (28, "Ni", "Nickel", "[Ar] 3d8 4s2", 58.693, 2, "A silvery-white metal that is used in coins, jewelry, and other decorative items."),
        (29, "Cu", "Copper", "[Ar] 3d10 4s1", 63.546, 2, "A soft, malleable, and ductile metal that has been used by humans for thousands of years, commonly used in electrical wiring and plumbing."),
        (30, "Zn", "Zinc", "[Ar] 3d10 4s2", 65.38, 2, "A bluish-white metal that is used in alloys, batteries, and as a coating on steel to prevent corrosion."),
        (31, "Ga", "Gallium", "[Ar] 3d10 4s2 4p1", 69.723, 3, "A soft, silvery metal that has a low melting point and is used in semiconductors and LEDs."),
        (32, "Ge", "Germanium", "[Ar] 3d10 4s2 4p2", 72.63, 4, "A metalloid element that is used in semiconductors, optical fibers, and other electronic devices."),
        (33, "As", "Arsenic", "[Ar] 3d10 4s2 4p3", 74.922, -3, "A metalloid element that is used in some alloys and as a pesticide."),
        (34, "Se", "Selenium", "[Ar] 3d10 4s2 4p4", 78.96, -2, "A nonmetal element that is used in glassmaking, electronics, and as a dietary supplement."),
        (35, "Br", "Bromine", "[Ar] 3d10 4s2 4p5", 79.904, -1, "A dark-red liquid that is highly reactive and is used in flame retardants and some medical procedures."),
        (36, "Kr", "Krypton", "[Ar] 3d10 4s2 4p6", 83.798, 0, "A colorless, odorless, and inert gas that is used in some lighting applications."),
        (37, "Rb", "Rubidium", "[Kr] 5s1", 85.468, 1, "A soft, silvery-white metal that is highly reactive and is used in some types of atomic clocks."),
        (38, "Sr", "Strontium", "[Kr] 5s2", 87.62, 2, "A soft, silvery-white metal that is highly reactive and is used in some types of fireworks."),
        (39, "Y", "Yttrium", "[Kr] 4d1 5s2", 88.906, 3, "A silvery-white metal that is used in some alloys and as a catalyst in the production of polymers."),
        (40, "Zr", "Zirconium", "[Kr] 4d2 5s2", 91.224, 4, "A strong, corrosion-resistant metal that is used in nuclear reactors and as a component of some alloys."),
        (41, "Nb", "Niobium", "[Kr] 4d4 5s1", 92.906, 5, "A soft, gray metal that is used in some alloys and as a superconductor."),
        (42, "Mo", "Molybdenum", "[Kr] 4d5 5s1", 95.94, 6, "A silvery-white metal that is used in some alloys and as a catalyst in the production of chemicals."),
        (43, "Tc", "Technetium", "[Kr] 4d5 5s2", 98.0, 7, "A radioactive metal that has no stable isotopes and is used in some medical imaging techniques."),
        (44, "Ru", "Ruthenium", "[Kr] 4d7 5s1", 101.07, 4, "A hard, white metal that is used in some alloys and as a catalyst."),
        (45, "Rh", "Rhodium", "[Kr] 4d8 5s1", 102.91, 3, "A rare, silvery-white metal that is used in some alloys and as a catalyst."),
        (46, "Pd", "Palladium", "[Kr] 4d10", 106.42, 2, "A soft, silvery-white metal that is used in catalytic converters, jewelry, and electronics."),
        (47, "Ag", "Silver", "[Kr] 4d10 5s1", 107.87, 1, "A soft, white, and lustrous metal that is used in jewelry, coins, and some electrical applications."),
        (48, "Cd", "Cadmium", "[Kr] 4d10 5s2", 112.41, 2, "A soft, bluish-white metal that is used in batteries, pigments, and some types of solder."),
        (49, "In", "Indium", "[Kr] 4d10 5s2 5p1", 114.82, 3, "A soft, silvery-white metal that is used in some alloys and in the production of LCD screens."),
        (50, "Sn", "Tin", "[Kr] 4d10 5s2 5p2", 118.71, 4, "A soft, silvery-white metal that is used in the production of alloys, coatings, and some types of solder."),
        (51, "Sb", "Antimony", "[Kr] 4d10 5s2 5p3", 121.76, -3, "A metalloid element that is used in some alloys and as a flame retardant."),
        (52, "Te", "Tellurium", "[Kr] 4d10 5s2 5p4", 127.6, -2, "A metalloid element that is used in some alloys and as a semiconductor."),
        (53, "I", "Iodine", "[Kr] 4d10 5s2 5p5", 126.9, -1, "A purple-black solid that is used in some medical procedures and as a disinfectant."),
        (54, "Xe", "Xenon", "[Kr] 4d10 5s2 5p6", 131.29, 0, "A colorless, odorless, and inert gas that is used in some lighting applications."),
        (55, "Cs", "Cesium", "[Xe] 6s1", 132.91, 1, "A soft, silvery-gold metal that is highly reactive and is used in some types of atomic clocks."),
        (56, "Ba", "Barium", "[Xe] 6s2", 137.33, 2, "A soft, silvery-white metal that is highly reactive and is used in some types of medical imaging."),
        (57, "La", "Lanthanum", "[Xe] 5d1 6s2", 138.91, 3, "A silvery-white metal that is used in some types of lighting applications and in the production of some alloys."),
        (58, "Ce", "Cerium", "[Xe] 4f1 5d1 6s2", 140.12, 3, "A silvery-white metal that is used in some types of lighting applications and as a catalyst in the production of fuels."),
        (59, "Pr", "Praseodymium", "[Xe] 4f3 6s2", 140.91, 3, "A soft, silvery metal that is used in some types of magnets and as a component of some alloys."),
        (60, "Nd", "Neodymium", "[Xe] 4f4 6s2", 144.24, 3, "A silvery-white metal that is used in some types of magnets and as a component of some alloys."),
        (61, "Pm", "Promethium", "[Xe] 4f5 6s2", 145.0, 3, "A radioactive metal that has no stable isotopes and is used in some types of nuclear batteries."),
        (62, "Sm", "Samarium", "[Xe] 4f6 6s2", 150.36, 3, "A silvery-white metal that is used in some types of magnets and as a neutron absorber."),
        (63, "Eu", "Europium", "[Xe] 4f7 6s2", 151.96, 3, "A silvery-white metal that is used in some types of lighting applications and as a neutron absorber."),
        (64, "Gd", "Gadolinium", "[Xe] 4f7 5d1 6s2", 157.25, 3, "A silvery-white metal that is used in some types of medical imaging and as a neutron absorber."),
        (65, "Tb", "Terbium", "[Xe] 4f9 6s2", 158.93, 3, "A silvery-white metal that is used in some types of lighting applications and as a component of some alloys."),
        (66, "Dy", "Dysprosium", "[Xe] 4f10 6s2", 162.5, 3, "A silvery-white metal that is used in some types of magnets and as a neutron absorber."),
        (67, "Ho", "Holmium", "[Xe] 4f11 6s2", 164.93, 3, "A silvery-white metal that is used in some types of magnets and as a component of some alloys."),
        (68, "Er", "Erbium", "[Xe] 4f12 6s2", 167.26, 3, "A silvery-white metal that is used in some types of lasers and as a component of some alloys."),
        (69, "Tm", "Thulium", "[Xe] 4f13 6s2", 168.93, 3, "A silvery-gray metal that is used in some types of medical imaging and as a component of some alloys."),
        (70, "Yb", "Ytterbium", "[Xe] 4f14 6s2", 173.05, 3, "A silvery-white metal that is used in some types of medical imaging and as a component of some alloys."),
        (71, "Lu", "Lutetium", "[Xe] 4f14 5d1 6s2", 175.0, 3, "A silvery-white metal that is used in some types of medical imaging and as a catalyst in the production of some chemicals."),
        (72, "Hf", "Hafnium", "[Xe] 4f14 5d2 6s2", 178.49, 4, "A lustrous, silvery metal that is used in some types of nuclear reactors and as a component of some alloys."),
        (73, "Ta", "Tantalum", "[Xe] 4f14 5d3 6s2", 180.95, 5, "A blue-gray metal that is used in some types of capacitors and as a component of some alloys."),
        (74, "W", "Tungsten", "[Xe] 4f14 5d4 6s2", 183.84, 6, "A dense, gray metal that is used in some types of electrical contacts and as a component of some alloys."),
        (75, "Re", "Rhenium", "[Xe] 4f14 5d5 6s2", 186.21, 7, "A silvery-white metal that is used in some types of superalloys and as a catalyst in the production of chemicals."),
        (76, "Os", "Osmium", "[Xe] 4f14 5d6 6s2", 190.23, 4, "A hard, brittle metal that is used in some types of electrical contacts and as a component of some alloys."),
        (77, "Ir", "Iridium", "[Xe] 4f14 5d7 6s2", 192.22, 3, "A dense, silvery-white metal that is used in some types of electrical contacts and as a component of some alloys."),
        (78, "Pt", "Platinum", "[Xe] 4f14 5d9 6s1", 195.08, 2, "A dense, malleable, and ductile metal that is used in jewelry, electrical contacts, and as a catalyst in the production of chemicals."),
        (79, "Au", "Gold", "[Xe] 4f14 5d10 6s1", 196.97, 1, "A soft, yellow, and malleable metal that is used in jewelry, electrical contacts, and some medical procedures."),
        (80, "Hg", "Mercury", "[Xe] 4f14 5d10 6s2", 200.59, 2, "A dense, silvery-white liquid that is highly toxic and is used in some types of thermometers, dental fillings, and some electrical applications."),
        (81, "Tl", "Thallium", "[Xe] 4f14 5d10 6s2 6p1", 204.38, 3, "A soft, bluish-white metal that is highly toxic and is used in some types of medical imaging and as a component of some alloys."),
        (82, "Pb", "Lead", "[Xe] 4f14 5d10 6s2 6p2", 207.2, 4, "A soft, dense, and bluish-gray metal that is highly toxic and is used in some types of batteries, pipes, and some electrical applications."),
        (83, "Bi", "Bismuth", "[Xe] 4f14 5d10 6s2 6p3", 208.98, 5, "A pinkish-white metal that is used in some types of alloys and as a substitute for lead in some applications."),
        (84, "Po", "Polonium", "[Xe] 4f14 5d10 6s2 6p4", 209.0, -2, "A highly radioactive metal that has no stable isotopes and is used in some types of nuclear batteries."),
        (85, "At", "Astatine", "[Xe] 4f14 5d10 6s2 6p5", 210.0, -1, "A highly radioactive element that has no stable isotopes and is used in some types of cancer treatments."),
        (86, "Rn", "Radon", "[Xe] 4f14 5d10 6s2 6p6", 222.0, 0, "A colorless, odorless, and radioactive gas that is highly toxic and is found in some types of rock and soil."),
        (87, "Fr", "Francium", "[Rn] 7s1", 223.0, 1, "A highly radioactive metal that has no stable isotopes and is very rare in nature."),
        (88, "Ra", "Radium", "[Rn] 7s2", 226.03, 2, "A highly radioactive metal that has no stable isotopes and is used in some types of medical treatments."),
        (89, "Ac", "Actinium", "[Rn] 6d1 7s2", 227.03, 3, "A radioactive metal that has no stable isotopes and is used in some types of medical treatments."),
        (90, "Th", "Thorium", "[Rn] 6d2 7s2", 232.04, 4, "A weakly radioactive metal that is used in some types of nuclear reactors and as a component of some alloys."),
        (91, "Pa", "Protactinium", "[Rn] 5f2 6d1 7s2", 231.04, 5, "A radioactive metal that has no stable isotopes and is used in some types of nuclear reactors."),
        (92, "U", "Uranium", "[Rn] 5f3 6d1 7s2", 238.03, 6, "A weakly radioactive metal that is used in some types of nuclear reactors and as a component of some alloys."),
        (93, "Np", "Neptunium", "[Rn] 5f4 6d1 7s2", 237.05, 5, "A radioactive metal that has no stable isotopes and is used in some types of nuclear reactors."),
        (94, "Pu", "Plutonium", "[Rn] 5f6 7s2", 244.06, 4, "A radioactive metal that has no stable isotopes and is used in some types of nuclear reactors and as a component of some alloys."),
        (95, "Am", "Americium", "[Rn] 5f7 7s2", 243.06, 3, "A radioactive metal that has no stable isotopes and is used in some types of smoke detectors."),
        (96, "Cm", "Curium", "[Rn] 5f7 6d1 7s2", 247.07, 3, "A radioactive metal that has no stable isotopes and is used in some types of nuclear reactors."),
        (97, "Bk", "Berkelium", "[Rn] 5f9 7s2", 247.07, 3, "A radioactive metal that has no stable isotopes and is used in some types of nuclear reactors."),
        (98, "Cf", "Californium", "[Rn] 5f10 7s2", 251.08, 3, "A radioactive metal that has no stable isotopes and is used in some types of nuclear reactors."),
        (99, "Es", "Einsteinium", "[Rn] 5f11 7s2", 252.08, 3, "A radioactive metal that has no stable isotopes and is used in some types of nuclear reactors."),
        (100, "Fm", "Fermium", "[Rn] 5f12 7s2", 257.1, 3, "A radioactive metal that has no stable isotopes and is used in some types of nuclear reactors."),
        (101, "Md", "Mendelevium", "[Rn] 5f13 7s2", 258.1, 3, "A radioactive metal that has no stable isotopes and is used in some types of nuclear reactors."),
        (102, "No", "Nobelium", "[Rn] 5f14 7s2", 259.1, 3, "A radioactive metal that has no stable isotopes and is used in some types of nuclear reactors."),
        (103, "Lr", "Lawrencium", "[Rn] 5f14 6d1 7s2", 262.11, 3, "A radioactive metal that has no stable isotopes and is used in some types of nuclear reactors."),
        (104, "Rf", "Rutherfordium", "[Rn] 5f14 6d2 7s2", 267.13, 4, "A radioactive metal that has no stable isotopes and is used in some types of nuclear reactors."),
        (105, "Db", "Dubnium", "[Rn] 5f14 6d3 7s2", 270.13, 5, "A radioactive metal that has no stable isotopes and is used in some types of nuclear reactors."),
        (106, "Sg", "Seaborgium", "[Rn] 5f14 6d4 7s2", 271.14, 6, "A radioactive metal that has no stable isotopes and is used in some types of nuclear reactors."),
        (107, "Bh", "Bohrium", "[Rn] 5f14 6d5 7s2", 270.13, 7, "A radioactive metal that has no stable isotopes and is used in some types of nuclear reactors."),
        (108, "Hs", "Hassium", "[Rn] 5f14 6d6 7s2", 277.15, 8, "A radioactive metal that has no stable isotopes and is used in some types of nuclear reactors."),
        (109, "Mt", "Meitnerium", "[Rn] 5f14 6d7 7s2", 278.16, 9, "A radioactive metal that has no stable isotopes and is used in some types of nuclear reactors."),
        (110, "Ds", "Darmstadtium", "[Rn] 5f14 6d9 7s1", 281.17, 10, "A radioactive metal that has no stable isotopes and is used in some types of nuclear reactors."),
        (111, "Rg", "Roentgenium", "[Rn] 5f14 6d10 7s1", 280.17, 11, "A radioactive metal that has no stable isotopes and is used in some types of nuclear reactors."),
        (112, "Cn", "Copernicium", "[Rn] 5f14 6d10 7s2", 285.18, 12, "A highly radioactive metal that has no stable isotopes and is used in some types of nuclear research."),
        (113, "Nh", "Nihonium", "[Rn] 5f14 6d10 7s2 7p1", 284.18, 13, "A highly radioactive metal that has no stable isotopes and is used in some types of nuclear research."),
        (114, "Fl", "Flerovium", "[Rn] 5f14 6d10 7s2 7p2", 289.19, 14, "A highly radioactive metal that has no stable isotopes and is used in some types of nuclear research."),
        (115, "Mc", "Moscovium", "[Rn] 5f14 6d10 7s2 7p3", 288.19, 15, "A highly radioactive metal that has no stable isotopes and is used in some types of nuclear research."),
        (116, "Lv", "Livermorium", "[Rn] 5f14 6d10 7s2 7p4", 293.2, 16, "A highly radioactive metal that has no stable isotopes and is used in some types of nuclear research."),
        (117, "Ts", "Tennessine", "[Rn] 5f14 6d10 7s2 7p5", 294.21, 17, "A highly radioactive metal that has no stable isotopes and is used in some types of nuclear research."),
        (118, "Og", "Oganesson", "[Rn] 5f14 6d10 7s2 7p6", 294.21, 18, "A highly radioactive metal that has no stable isotopes and is used in some types of nuclear research.")
    ]

    
    var body: some View {
        ScrollView(.vertical) {
            LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: isIPad ? 6 : 3), spacing: 16) {
                ForEach(elements, id: \.0) { (index, symbol, name, config, mass, charge, description) in
                    NavigationLink(destination: ElementView(element: symbol, name: name)) {
                        VStack {
                            ElementSymbolView(symbol: symbol, description: description)
                                .frame(width: 50, height: 50)
                            Text(name)
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                    }
                    .buttonStyle(PlainButtonStyle())
                }
            }
            .padding()
        }
        .navigationTitle("Periodic Table")
    }
}


struct AtomsView_Previews: PreviewProvider {
    static var previews: some View {
        AtomsView()
    }
}

struct ElementSymbolView: View {
    let symbol: String
    let description : String
    
    var body: some View {
        Text(description)
            .font(.system(size: 24, weight: .bold))
            .frame(width: 50, height: 50)
            .background(Color.gray.opacity(0.1))
                .clipShape(Circle())}
}
struct ElementView: View {
    let element: String
    let name: String
    var body: some View {
        VStack {
            Text(element)
                .font(.system(size: 96, weight: .bold))
            Text(name)
                .font(.title)
                .padding(.bottom)
            Text("This is the \(name) element. Its symbol is \(element).")
                .padding(.horizontal)
            Spacer()
        }
        .navigationBarTitle(name)
    }
}
