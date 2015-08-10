//
//  TableOfContent.swift
//  Kai Aldag
//
//  Created by Kai Aldag on 2015-04-18.
//  Copyright (c) 2015 Kai Aldag. All rights reserved.
//

import UIKit

struct TableOfContent {
    static var presenters: [ContentPresenter] = [
        ContentPresenter(header: headers.first!, sections: sections.first!),
        ContentPresenter(header: headers[1], sections: sections[1]),
        ContentPresenter(header: headers[2], sections: sections[2]),
        ContentPresenter(header: headers.last!, sections: sections.last!),
    ]
    
    static let headers = [
        Header(title: "About Me", heroImage: UIImage(named: "about-me")!),
        Header(title: "Development & Design", heroImage: UIImage(named: "kai-coding")!),
        Header(title: "Academic", heroImage: UIImage(named: "kai-ship-1")!),
        Header(title: "Kai + WWDC", heroImage: UIImage(named: "wwdc-hero")!)
    ]
    
    static var sections: [[Section]] = [
        // About Me
        [
            Section(title: "A Brief Intro", content: content[0][0]),
            Section(title: "Interests", content: content[0][1])
        ],
        // Development & Design
        [
            Section(title: "Development", content: content[1][0]),
            Section(title: "Design", content: content[1][1]),
            Section(title: "My Projects", content: content[1][2])
        ],
        // Academics
        [
            Section(title: "High-School", content: content[2][0]),
            Section(title: "University", content: content[2][1])
        ],
        // Academics
        [
            Section(title: "High-School", content: content[2][0]),
            Section(title: "University", content: content[2][1])
        ],
        // Kai + WWDC
        [
            Section(title: "What It Would Mean To Me", content: content[3][0]),
            Section(title: "So Thank You", content: content[3][1])
        ]
    ]
    
    static let content: [[[Content]]] = [
        // About Me
        [
            [
                Content.Paragraph("Hi! I’m Kai, a 14-year-old from Langley, Canada, who’s always had a love of learning and building beautiful things. Growing up I was very intrigued by science, business and most of all, technology. And as I became older I ventured into each of these fields but the two that really clicked with me were business and technology.")
            ],
            
            [
                Content.Paragraph("I’ve always loved music and it only seemed fitting for me to learn how to play it too. I am very into jazz, and I also like the band Coldplay so I love to jam out on my acoustic guitar and I really enjoy improvising on piano!"),
                Content.Image(UIImage(named: "guitar")!, nil, true),
                Content.Paragraph("For my 10th birthday my parents gave me a rather unorthodox gift: an introductory class in Scuba diving and a big bucket of KFC beforehand. Not exactly a perfect match. After that I just loved to cruise around the sea floor and spot all the amazing marine life. This really made me appreciate how important it is to have a sustainable environment."),
                Content.Image(UIImage(named: "kai-diving-solo")!, nil, true),
                Content.Paragraph("Just like any other kid my age I love to play video games and watch movies. More specifically, I love retro videogames and like to watch new blockbuster comedies and action films."),
                Content.Paragraph("When I was a little kid I heard about some worldwide financial crisis. Naturally, I was very curious so I went onto ‘Khan Academy’ and watched their section on the market crash of ’08. I realized how interesting business really was. From then on I’ve always loved to hear about new and trending things in the world of business."),
                Content.Paragraph("Technology is something that I’ve always been intrigued by, and wanted to get more into. More on that in the next section."),
                Content.Shimmering("Swipe left to go to the next section", .Left, UIImage(named: "kai-coding")!)
            ]
        ],
        // Development & Design
        [
            [
                Content.Paragraph("I started to code when I was about 10 years old. I started off on the family desktop where I’d spend hours on end tinkering with basic HTML and CSS. I made websites to make my little sisters laugh and for my own enjoyment. One thing I remember was when I started in JavaScript. I created little buttons with a tagline to a joke - upon tapping, the punchline would appear in an alert view."),
                Content.Paragraph("Eventually, I realized I really liked coding and wanted to do it more seriously. I had to pick a route to follow and it was obvious, iOS apps. I was sold on the idea of learning how to build gorgeous apps that could potentially influence millions of people's daily lives and could really make a difference in the world. There was one hold up, you needed a mac. So, I pestered my parents until they got me a MacBook air 2012. I was 11. The first app I installed was Xcode."),
                Content.Paragraph("With that my journey began. Over the next year or so I spent countless hours learning from Treehouse, Youtube videos and Stanford’s CS193p class of 2010’s online videos. I learned a lot from those sources (along with many generous people online who helped me squash the bugs in my apps). Eventually I saw a posting for a part time teaching assistant in downtown Vancouver at a company called Lighthouse Labs. I contacted the company and went for an interview."),
                Content.Image(UIImage(named: "kai-working")!, "At Lighthouse Labs", false),
                Content.Paragraph("I showed off my work, but didn’t really know how much I didn't know. I enrolled in the first iOS cohort at LightHouse Labs. The program started in July 2014. It was an 8 week program that I was going to fit into my summer holidays between grade 7 & 8. For my midterm assignment I made a photo editing app that allows you to take photos, edit them, then share them to your social media accounts. I is called Capture. My final project was a social integrated music player where you can stream all your music and share it with your friends. Mixta.")
            ],
            [
                Content.Paragraph("I love coding, but design has always come as second nature to me. I love to sit down and design with a pencil and paper the apps I plan to one day build. I've always liked to dissect other people's apps (specifically the Apple Design Award nominees and winners) and see what makes them so aesthetically pleasing and what they do differently. I believe to effectively design an app you need the right balance between convention and innovation. You need to make it easy and understandable to navigate as well as interactive and intriguing to use."),
                Content.Quote("“Excellence is to do a common thing in an uncommon way.”\n—Booker Washington."),
                Content.Paragraph("There is so much thought required to build a beautiful app. Everything from ”what font to use?“ to ”what color should this be?” to ”how many pixels to the right should that button should go?”. It’s the little changes that make a big difference."),
                Content.Image(UIImage(named: "kai-writing-dark")!, nil, true)
            ],
            [
                Content.Paragraph("Capture: this photo editing app is my midterm assignment at Lighthouse Labs. I wanted to make an app to provide the same level of photo editing as Instagram but without having to post. For Capture I harnessed a framework called ’GPUImage’ to handle all the editing, I then added a ’share sheet’ so you could email it, text it, post on facebook or tweet it!"),
                Content.Image(UIImage(named: "screenshots")!, nil, false),
                Content.Paragraph("Mixta: A social integrated music player. I created this to share my music with my friends despite us all using different platforms. Why not make an app that pulls all of them together into one place regardless of where we listen to it.\nCurrently I'm working on the backend so I can have a place to store all the data the app will require."),
                Content.Paragraph("After having done the 8-week iOS program and a couple months of experience I was hired by Lighthouse Labs as a teaching assistant. "),
                Content.Image(UIImage(named: "kai-ta")!, "Helping students at Lighthouse Labs", false),
                Content.Paragraph("I also helped out at the HTML500. This is a ”learn to code event” where 500 people came out to learn the basics of HTML and CSS in one day."),
                Content.Paragraph("When I was learning on Treehouse I always had great people to help me out with my problems. I only saw it fair to return the favour by dedicating time to answering questions and QA testing courses for students. This eventually earned me the title of ’Moderator’."),
                Content.Shimmering("Swipe left or right", .Right, UIImage(named: "kai-ship-1")!)
            ]
        ],
        // Academics
        [
            [
                Content.Paragraph("I’m currently in grade 8 at Walnut Grove Secondary School (WGSS), in their French immersion program meaning all my courses are in French with the exceptions being English class and my electives. The courses I quite enjoy are Mathematics, Computer Graphics and Electronics."),
                Content.Paragraph("This year I decided to take some courses online, including Advanced Placement in Computer Science. The course teaches the fundamentals of programming using Java, which is also the language of our assignments and tests."),
                Content.Paragraph("WGSS offers many clubs, one of them being a robotics club. I never really looked into this club until they announced they needed a programmer to fix their code problems. I ended up reviewing and solving the problem. I joined the robotics club (software side) so I could contribute to the team's success at the competition in Calgary (April 2015). At the end of the two days we returned home with two awards, ’Rookie inspiration award’ and ’Rookie seed award’ (highest ranking rookie team) making us the team to bring home the most trophies ever in our province!"),
                Content.Image(UIImage(named: "awards")!, "The awards", false)
            ],
            [
                Content.Paragraph("Upon graduating high-school in 2019 I would love to attend Stanford to do a bachelors and masters in computer science."),
                Content.Shimmering("Swipe left or right", .Right, UIImage(named: "wwdc-hero")!)
            ],
        ],
        // Kai + WWDC
        [
            [
                Content.Paragraph("To win the Apple student scholarship would be such an indescribable honour and would certainly make me feel that this whole crazy adventure is really taking form and going somewhere. It would be such a pivotal moment in my career as a developer."),
                Content.Paragraph("Apple has always been more then a just a tech company to me. Apple has provided me a great community to develop and design my apps and a vibrant and diverse market to publish them in. I’ve learned so much from Apple already and I hope to learn even more in person at WWDC 2015."),
                Content.Paragraph("Being able to attend WWDC would also allow me to meet like-minded students and STEM members that could lead to lifelong friendships and partnerships. It would also allow me to truly thank all those who’ve helped me so much as an individual to grow into the developer I am today. for this I am eternally grateful."),
                Content.Image(UIImage(named: "kai-twitter-flight-1")!, "At Twitter Flight 2014", true)
            ],
            [
                Content.Paragraph("Thank you for checking out my app and learning a bit about me. I hope I get the ultimate chance to thank all those who’ve helped me, in person at WWDC 2015."),
                Content.Image(UIImage(named: "wwdc-logo")!, "(Edited using Capture)", false),
                Content.Shimmering("Swipe right to go back", .Right, UIImage(named: "about-me")!)
            ]
        ]
    ]
}