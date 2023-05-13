import Foundation

/**
   A model that represents an article.

   ATOMIZER
   Developed and Designed by John Seong.
 */

struct Article: Codable, Identifiable {
    let id: UUID
    let title: String
    let subtitle: String
    let imageUrl: String
    let content: String
    
    init(title: String, subtitle: String, imageUrl: String, content: String) {
        self.id = UUID()
        self.title = title
        self.subtitle = subtitle
        self.imageUrl = imageUrl
        self.content = content
    }
}

let instruction1 = Article(title: "HOMO and LUMO?",
                           subtitle: "Molecular Orbital Theory",
                           imageUrl: "molecular-orbital",
                           content: "> HOMO stands for **Highest Occupied Molecular Orbital** and LUMO stands for **Lowest Unoccupied Molecular Orbital**.\n\nThink of HOMO as the **top floor of a building** and LUMO as the **basement**. HOMO is where the electrons hang out the most and LUMO is where they like to go when they're excited.\n\nBonding orbitals are like **friendly hugs** between atoms. Antibonding orbitals are like **two people pushing against each other**.\n\nTo sum up, bonding orbitals allow for the formation of chemical bonds, which correspond to the HOMO. Antibonding orbitals prevent bonding, which is equivalent to the LUMO.\n\n![Image1](homo-lumo-1)\n\n*Source: UCalgary*\n\n> Ethene is a molecule that has two carbon atoms and four hydrogen atoms. Just like buddies who support each other, the carbon atoms and hydrogen atoms bond together to form a tight-knit group, sharing their electrons and creating a stable molecule.\n\nIn ethene, the two carbon balls connect to each other using a strong bond that we call the 'double bond'. This bond is made up of two parts: the sigma bond and the pi bond. The sigma bond is like a tight hug between the two carbon balls. The pi bond is like a sideways high five.\n\nThe pi bond is made by the dumbbell-shaped p orbitals. But because of the strong sigma bond, the p orbitals have to bend to fit together. They look like two bananas overlapping each other, and this is called the 'banana bond'. It's a funny name, but it's important because it makes the pi bond strong and helps hold the two carbon balls together.\n\n")

let instruction2 = Article(title: "Swift Student Challenge!",
                           subtitle: "Visiting Apple Park & Meeting CEO Tim Cook",
                           imageUrl: "san-francisco",
                           content: "My name is John Seong. I am in my final year of high school here in Toronto, Canada.\n\nI will be attending **University of California, Irvine** starting from September 2023.\n\n> I am happy to share the news that I will be heading to San Francisco Apple Park HQ this June 5, as a Swift Student Challenge / WWDC23 Scholar.\n\nI was lucky enough to be invited to the in-person event as a student developer who was nominated for this award.\n\nOut of 350 students worldwide who have received the award, only less than 10 people get to be invited to this exclusive event in Cupertino, CA.\n\n![Image1](wwdc)\n\n> I look forward to meeting Apple's top engineers and executives like Tim Cook and Craig Federighi!\n\nI remember spending my youth watching the Apple Special Events, in awe of the great design, and the technology. I can't believe that I will be heading to San Francisco, to partake in the actual event!\n\n*To contact me, simply shoot an email to: johnseong@havit.space*")

let instruction3 = Article(title: "No More Bohr Diagrams.",
                           subtitle: "Introduction to Modern Physics",
                           imageUrl: "equation",
                           content: "> Bohr's atomic model, proposed in 1913, introduced the idea of electrons orbiting the nucleus in specific energy levels or shells.\n\nThis model was revolutionary at the time, as it explained the spectrum of light emitted by hydrogen atoms.\n\nHowever, Bohr's atomic model had limitations. For example, it failed to explain the spectrum of other elements and could not account for the behavior of atoms in chemical reactions. In addition, it did not account for the wave-like behavior of electrons.\n\n![Image1](atomic-models)\n\n> Modern atomic theory, on the other hand, builds upon Bohr's model and introduces the concept of atomic orbitals, which are regions of space around the nucleus where electrons are likely to be found.\n\nEach orbital can hold a maximum of two electrons with opposite spin. This theory also introduces the concept of electron density, which describes the probability of finding an electron at a given location around the nucleus.\n\nBy incorporating the wave-like behavior of electrons and introducing more precise descriptions of electron behavior and arrangement, modern atomic theory provides a more detailed and accurate understanding of the structure of atoms than Bohr's atomic model.")

let koInstruction1 = Article(title: "결합/반결합 분자 오비탈",
                           subtitle: "분자 오비탈 이론",
                           imageUrl: "molecular-orbital",
                           content: "> HOMO는 최고 점유 분자 오비탈 (Highest Occupied Molecular Orbital) 를 의미하며, LUMO는 최저 미점유 분자 오비탈 (Lowest Unoccupied Molecular Orbital) 를 의미합니다.\n\nHOMO를 지상 3층에 있는 스터디카페로 생각하고, LUMO를 지하에 있는 PC방으로 생각해보세요. HOMO는 전자가 가장 많이 머무르는 곳이며, LUMO는 전자들이 들떠 있을 때 가장 가고 싶어하는 장소입니다.\n\n결합 궤도는 원자들 간의 우정의 포옹과 같습니다. 반결합 궤도는 두 사람이 서로 밀치는 것과 같습니다.\n\n따라서, 결합 궤도는 화학 결합 형성을 허용하며, 이는 HOMO에 해당합니다. 반결합 궤도는 결합을 방지하며, 이는 LUMO에 해당합니다.\n\n![Image1](homo-lumo-1)\n\n출처: UCalgary\n\n> 에테인은 두 개의 탄소 원자와 네 개의 수소 원자로 이루어진 분자입니다. 서로를 지지하는 친구처럼, 탄소 원자와 수소 원자는 전자를 공유하여 안정적인 분자를 형성합니다.\n\n에테인에서는 두 개의 탄소 구체가 '이중 결합'이라고 하는 강한 결합으로 연결됩니다. 이 결합은 시그마 결합과 파이 결합으로 이루어져 있습니다. 시그마 결합은 두 개의 탄소 구체 사이의 포옹과 같습니다. 파이 결합은 측면에서의 악수와 같습니다.\n\n파이 결합은 아령 모양의 p 궤도에 의해 형성됩니다. 그러나 강한 시그마 결합 때문에 p 궤도는 결합하기 위해 구부러져야 합니다. 두 개의 바나나가 서로 겹쳐진 모양처럼 보이며, 이를 '바나나 결합'이라고 합니다. 이것은 재미있는 이름이지만, 파이 결합을 강하게 만들고 두 개의 탄소 구체를 함께 유지하는 데 도움이 되는 중요한 역할을 합니다.\n\n")
