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
                           content: "My name is John Seong and I am in my final year of high school here in Toronto, Canada.\n\nI will be attending **University of California, Irvine** starting from September 2023.\n\n> I am happy to share the news that I will be heading to San Francisco Apple Park HQ this June 5, as a Swift Student Challenge / WWDC23 Scholar.\n\nI was lucky enough to be invited to the in-person event as a student developer who was nominated for this award.\n\nOut of 350 students worldwide who have received the award, only less than 10 people get to be invited to this exclusive event in Cupertino, CA.\n\n![Image1](wwdc)\n\n> I look forward to meeting Apple's top engineers and executives like Tim Cook and Craig Federighi!\n\nI remember spending my youth mindlessly watching the Apple Special Events, in awe of the great design, and the technology. I can't believe that I will be heading to San Francisco, to partake in the actual event!\n\n*To contact me, simply shoot an email to: johnseong@havit.space*")
