#import "@preview/pubmatter:0.2.2"
#import "@preview/scienceicons:0.1.0": osi-icon

#let fm = pubmatter.load((
  title: "PoC: Decentralized Zero-Trust & Zero-Knowledge Voting System",
  subtitle: "Blockchain-based voting system, where votes are encrypted using multiparty homomorphic encryption",
  short-title: "Voting System",
  author: (
    (
      name: "zefr0x",
      github: "zefr0x"
      // email: "",
      // affiliations: "",
    ),
  ),
  open-access: true,
  license: "CC-BY-NC-4.0",
  // venue: "",
  date: datetime(year: 2024, month: 12, day: 13),
  // doi: "",
  abstract: [
    This paper explores the design and implementation of a trustless decentralized voting system leveraging blockchain technology, multiparty computation (MPC), and homomorphic encryption. The proposed system ensures votes' privacy and transparency by encrypting them in a way that allows computations to be performed on the ciphertexts without decrypting them. The system operates in a decentralized environment with no trust in any party and all operations are collaboratively distributed. The proof-of-concept implementation demonstrates the feasibility of such a system, utilizing immature cryptographic technologies. However, it faced limitations related to input validation and fault tolerance. Future work should focus on improving cryptographic algorithms with threshold-based fault tolerant decryption and strict data types.
  ],
  keywords: ("blockchain", "homomorphic encryption"),
))

#let github = "https://github.com/zefr0x/cys402_project_poc"

#set document(
  title: fm.title,
  author: fm.authors.map(author => author.name)
)

#let theme = (color: red.darken(20%), font: "Noto Sans")
#state("THEME").update(theme)

#set page(
  paper: "a4",
  margin: (left: 25%),
  header: pubmatter.show-page-header(fm),
  footer: pubmatter.show-page-footer(fm),
)

#let logo = [
    // #v(-13pt)
    // #image("")
    // #v(5pt)
    // #align(left)[
    //   #text(size: 19pt, weight: "bold", fill: rgb("#000000"), font: theme.font)[XXXX]
    //   #v(-6pt)
    //   #text(size: 12pt, style: "italic", weight: "light", fill: rgb("#000000"), font: theme.font)[XXXX School of XXXX]
    // ]
    // #v(5pt)
    // #set par(justify: true)
    // #text(size: 6pt, fill: black.lighten(20%), font: theme.font)[
    //   Journal of XXXX
    // ]
    // #text(size: 6pt, fill: black.lighten(40%), font: theme.font)[
    //   ISSN: XXXX-XXXX
    // ]
]

#show link: it => [#text(fill: theme.color)[#it]]
#show ref: it => {
    if (it.element == none)  {
      // This is a citation showing 2024a or [1]
      show regex("([\d]{1,4}[a-z]?)"): it => text(fill: theme.color, it)
      it
      return
    }
    // The rest of the references, like `Figure 1`
    set text(fill: theme.color)
    it
}

#set text(font: "Noto Serif", size: 9pt)

#set math.equation(numbering: "(1)")
#show math.equation: set block(spacing: 1em)
// Configure lists.
#set enum(indent: 10pt, body-indent: 9pt)
#set list(indent: 10pt, body-indent: 9pt)

// Configure headings.
#set heading(numbering: "1.")

#if (logo != none) {
  place(
    top,
    dx: -33%,
    float: false,
    box(
      width: 27%,
      {
        if (type(logo) == content) {
          logo
        } else {
          image(logo, width: 100%)
        }
      },
    ),
  )
}

#let kind = [Proof-of-Concept Study]

#place(
  left + bottom,
  dx: -33%,
  dy: -10pt,
  box(width: 27%, {
    set text(font: theme.font)
    if (kind != none) {
      show par: set par(spacing: 0em)
      text(11pt, fill: theme.color, weight: "semibold", smallcaps(kind))
      parbreak()
    }
    let dates = ((title: "Published", date: datetime(year: 2026, month: 3, day: 1)), (title: "Drafted", date: datetime(year: 2024, month: 12, day: 10)))
    let margin = (
  (
    title: [Open Access #h(1fr) #pubmatter.show-license-badge(fm)],
    content: [
      #set par(justify: true)
      #set text(size: 7pt)
      #pubmatter.show-copyright(fm)
    ]
  ),

  if github != none {
    (
      title: "Data Availability",
      content: [
        Source code (#osi-icon(color: rgb("#23861d"), baseline: 0.25em) GPL-3.0):\
        #link(github, github)
      ],
    )
  }).filter((m) => m != none)

    if (dates != none) {
      let formatted-dates

      grid(columns: (40%, 60%), gutter: 7pt,
        ..dates.zip(range(dates.len())).map((formatted-dates) => {
          let d = formatted-dates.at(0);
          let i = formatted-dates.at(1);
          let weight = "light"
          if (i == 0) {
            weight = "bold"
          }
          return (
            text(size: 7pt, fill: theme.color, weight: weight, d.title),
            text(size: 7pt, d.date.display("[month repr:short] [day], [year]"))
          )
        }).flatten()
      )
    }
    v(2em)
    grid(columns: 1, gutter: 2em, ..margin.map(side => {
      text(size: 7pt, {
        if ("title" in side) {
          text(fill: theme.color, weight: "bold", side.title)
          [\ ]
        }
        set enum(indent: 0.1em, body-indent: 0.25em)
        set list(indent: 0.1em, body-indent: 0.25em)
        side.content
      })
    }))
  }),
)

// #place(
//   left + bottom,
//   dx: -33%,
//   dy: 20pt,
//   box(width: 27%, {
//     link("")[#text(size: 8pt)[#XXXX-icon(color: rgb("#")) #text(fill: rgb("#"), font: "Avenir")[Published in XXXX]]]
//   }),
// )

#let details = [
  #pubmatter.show-license-badge(fm)

  #pubmatter.show-copyright(fm)
]

#pubmatter.show-title-block(fm)
#pubmatter.show-abstract-block(fm)

= Introduction

The system operates on a peer-to-peer network, where multiple parties collaboratively maintain a blockchain as a distributed ledger. As illustrated in #ref(<fig:system_overview>), during the voting process initialization, every participant contributes to the blockchain by appending their generated multiparty homomorphic (MHE) public-key-share. The share is then broadcast to the whole network by being on the blockchain. Crucially, while every public-key-share is public to the whole network, each participant retains their corresponding private-key in secret.

Once a sufficient number of participants have joined, a voting round can be initiated by generating a global-key. Any participant can aggregate public-key shares obtained via the blockchain into a unified global-key which can be used to encrypt each participant's vote before publishing it to the blockchain. This step ensures both private and transparent voting.

Utilizing properties of homomorphic encryption computations, operations can be done on the encrypted votes' contents without decrypting them. In this stage of the voting process, each participant can calculate the result independently to obtain an encrypted tally, which should be identical for everyone. After that, it's the job of every participating member to use his private key to partially decrypt the voting tally, resulting in a decryption share that's published to the blockchain. Finally, by aggregating all decryption shares from the blockchain, we get the final decrypted voting result, which is publicly available to everyone.

#figure(
  image("./assets/system_overview.mmd.pdf"),
  caption: [Overview of the system's design with two participants]
)<fig:system_overview>

= Implementation Details
Following is a list of tools and programming libraries used in the implementation:

// TODO: Add links/refrences to them.

- *Rust*: Fast and memory-safe programming language.
- *libp2p*: Peer-to-peer networking stack.
- *fhe.rs*: Rust library providing a basic implementation for multiparty BFV homomorphic scheme.
- *bincode*: Rust library for binary serialization and deserialization.
- *zstd*: Rust binding for the Zstd compression library.

== Blockchain Implementation

The proposed system was implemented in a way where parties collaboratively maintain a private blockchain as a distributed ledger. The used consensus mechanism is a proof of work (PoW) by calculating an MD5#footnote[Weak hash function.] hash to find a block where the hash value has its first byte as zeros#footnote[It is a weak condition, but suitable for testing purposes.]. A block can store different data types for different purposes.

The following are block types handled by the blockchain:
- *Common Polynomial*: A random polynomial that every node uses to generate their public-key share.
- *Public Key Share*: Share of the public key provided by every node.
- *Cipher Share*: Vote in its encrypted state, provided by every node.
- *Decryption Share*: The results in decrypted shares, can be aggregated for the final result.

== Networking Implementation

The system operates on a peer-to-peer network, with the Multicast DNS#footnote[A protocol that facilitates DNS-like operations on local links @rfc6762.] protocol used for peer discovery on the local network. Combined with the Floodsub#footnote[Very simple protocol where we just have two streams, an outbound and an inbound @pubsub.] protocol as the base of the network architecture, we created a full mesh network topology where messages are broadcast to the whole network. Moreover, every peer has an identifier to be specifically recognized, which can be used to open data stream channels between peers when transferring large blocks for the blockchain, without relying on the slow broadcast control channel.

All messages are serialized to a binary format and compressed using the Zstd algorithm#footnote[Fast and efficient lossless compression algorithm @rfc8878.]. And, before sending them via the transport layer (TCP/IP) in the network, an elliptic curve Diffie–Hellman key agreement is done for secure data transmission.

== Cryptography Implementation for Voting Data

Votes are based on the multiparty Brakerski/Fan-Vercauteren (BFV) scheme of homomorphic encryption @cryptoeprint:2020:304. This scheme enables doing computations on encrypted votes without decrypting them, providing privacy and transparency to the system.

To find the encrypted tally, we do a summation operation on all the ciphertexts encrypted using the global key. The number $1$ means that the participant voted-for, while $0$ means they voted-against, so the result after the decryption will be the count of voting-for.

= Challenges

== Large Key Sizes

Secure public-key shares and private keys tend to be very large in size for homomorphic encryption, which has a huge impact on the blockchain size and overhead in blocks transferring process between peers in the network. To avoid that, we used the Zstd compression algorithm, minimizing this impact. As seen in #ref(<fig:block_sizes_bar_graph>), for the larger and securest key, it resulted in a decrease from `31 MB` to `1.1 MB` in key block size.

#figure(
  image("./assets/graphs/block_sizes.pdf", width: 80%),
  caption: [Block sizes before and after compression]
)<fig:block_sizes_bar_graph>


== Unpolished Libraries and Immature Echosystem
The current state of homomorphic encryption programming libraries appears to be somewhat limited and unpolished. While the Lattigo#footnote[Golang lattice-based multiparty homomorphic encryption library @lattigo.] library in the Go language and OpenFHE#footnote[It does implement a considerably great amount of algorithms, useful for different purposes @OpenFHE.] in C++ are leading in supporting multiparty homomorphic encryption implementations. For the Rust language, we have TFHE-rs, which is developed by Zama#footnote[Cryptography company building homomorphic encryption solutions.] and currently provides the best solution for homomorphic encryption in Rust @TFHE-rs. However, currently, it doesn't have support for any type of multiparty solution#footnote[Since #cite(form: "year", <githubQuestionDoesTFHE-rs>) they are working on a threshold-based solution.], limiting our choice to Fhe.rs, the only library that could be used in Rust for our implementation. Nevertheless, we need some minor modifications to its source code for it to be useful, since it doesn't have any serialization capabilities to transfer keys and ciphertext between peers @githubGitHubTlepointfhers.

= Evaluation and Results

== Performance Metrics

We concluded from #ref(<fig:timings_plot>) that aggregation operations along with the votes tallying process time increase linearly as the count of participants increases. This trend suggests that the computational complexity of the voting process scales linearly with the number of participants in the network. While the linear increase is stable and predictable, it highlights the need for optimization to handle scaling more efficiently. However, for simple voting operations, this overhead doesn't have a huge effect, for example, if one hundred thousand people are participating in the tally it will take approximately just $3.5$ minutes in a relatively old and low-spec computer.

#figure(
  image("./assets/graphs/homomorphic_timings.pdf"),
  caption: [Timing comparison of cryptographic operations across different participants count]
)<fig:timings_plot>

== Results of the PoC

The Proof-of-Concept (PoC) implementation of the proposed system was successfully carried out and evaluated. The goal was to prove the feasibility of using current homomorphic encryption techniques for privacy-preserving decentralized voting networks. Below are the key results and observations from the PoC.

=== Functionality and Accuracy
The system demonstrated accurate tallying of votes without exposing individual votes, ensuring private and transparent handling of votes. The final results accurately reflected the total count of votes for and against, as expected.

=== Scalability and Performance
The system demonstrated an acceptable scalability with linear growth complexity, which makes it feasible for most cases.

=== Privacy and zero-trust
The system successfully provided statistical privacy without exposing any voting data, except the final result. Also, it doesn't rely on a single point of failure.

== Limitations

Despite the promising results, several limitations that should be improved remain in the system's design and implementation. These limitations must be addressed to enhance security for real-world deployments.

=== Input Validation and Data Types
The system assumes that input data are valid, either 0 or 1 value for a vote, which enables any malicious peer to vote with a larger number. This should be addressed by the cryptographic algorithm at the data type level where we should be able to specify some conditions with mathematical methods.

=== Blockchain Limitations
Peers don't have any limitation on adding blocks to the blockchain, which enables a peer to push the same block multiple times. This can lead to voting more than one time.

=== Fault Tolerance Limitations
If some peers didn't participate in the decryption process, we will not be able to decrypt the final result.

= Conclusion and Future Work

== Summary of Findings

This paper has explored the key mathematical foundations of decentralized networks, focusing on game theory, graph theory, and cryptographic techniques. We examined how these concepts enable the creation of zero-trust and zero-knowledge private systems that can operate without any central authority.

We presented a proof-of-concept implementation of a trustless and zero-knowledge voting system that leverages these mathematical foundations. This demonstrated the feasibility of such systems, utilizing the blockchain for integrity and transparency, homomorphic encryption for privacy-preserving computations, and multiparty computation to prevent any single point of failure.

Our evaluation showed promising results in terms of functionality and scalability. However, we identified areas for further research and improvement, including addressing input validation and fault tolerance mechanisms.

Homomorphic encryption algorithms are still considered immature, both in terms of their mathematical design and broader adoption. There are limitations in handling some data types as trusted inputs and a lack of robust tools and programming libraries facilitating and implementing homomorphic encryption. Outside of the research sector, we encourage developers to contribute to open-source implementations for homomorphic encryption algorithms and build an ecosystem around them.


#set page(margin: auto)
#set heading(numbering: none)
#show heading.where(level: 1): set align(center)
#show heading.where(level: 1): set block(below: 1.5em)

= References
#bibliography("refs.bib", title: none, style: "ieee")
