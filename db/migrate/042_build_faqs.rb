class BuildFaqs < ActiveRecord::Migration
  def self.up
    titles = %w{ About/Business Content Future Beyond }
    priority = 0
    titles.each do |title|
      faq_section = FaqSection.create(:title => title,
                                      :priority => priority += 1)
      faq_section.save!
    end
    
    populate_subsection(FaqSection.find_by_title("About/Business"),
                        %w{ About\ Us Business })
    populate_subsection(FaqSection.find_by_title("Content"),
                        %w{ Publishing Workshopping Lists Creativity })
    populate_subsection(FaqSection.find_by_title("Beyond"),
                        %w{ Academic\ Writing Professional\ Writing Miscellaneous })
    
    populate_questions(FaqSection.find_by_title("About Us"),
                       [["What is Scrawlers.com?",
                         "Scrawlers is a place for you to post your original 100-word story, get notes from other writers, and give notes to other writers. Everything is done in the name of improving our writing as a community."],
                        ["Who founded and maintains Scrawlers?",
                         "Barry Hess and Nathan Melcher."],
                        ["Where is Scrawlers based, geographically?",
                          "Scrawlers is intended for writers everywhere, but the founders live in Minnesota."]
                       ])
    populate_questions(FaqSection.find_by_title("Business"),
                       [["What is the Scrawlers copyright policy?",
                         "You own everything you post at Scrawlers, period."],
                        ["What is the Scrawlers privacy policy?",
                          "We will never sell your information to anyone, period. We will only send you the email you tell us you want, period."],
                        ["Who are Scrawlers&rsquo;s business partners?",
                          "Our list of business partners will be made apparent soon."],
                        ["How do I advertise with Scrawlers?",
                          "<a href='mailto:info@scrawlers.com'>Contact us</a> for rates."],
                        ["Why was my story/note/account deleted?",
                          "It was probably flagged for containing inappropriate content as deemed by Scrawlers staff."],
                        ["Where can I buy Scrawlers merchandise?",
                          "The future."],
                        ["Where is the FAQ?",
                          "You're kidding, right?"],
                       ])   
    populate_questions(FaqSection.find_by_title("Publishing"),
                       [["Why should I publish my story?",
                         "Scrawlers is about improving our writing. Having others read your work before the pressure of trying to publish it can be a first step in taking your story to the next level. Submit your work with an open mind, leave with several new opinions on your work, and rewrite accordingly."],
                        ["How do I publish my story?",
                          "Look for the big &quot;Scrawl!&quot; button. You can&rsquo;t miss it!"],
                        ["What are tags and how do I use them?",
                          "Tags are a way for writers to categorize their story. Writers can search for tag terms to find stories suited to their tastes, so choose tags you think represent something unique about your story. Broad terms like &quot;fiction&quot; or &quot;memoir&quot; are all right, but unique like &quot;bowtie&quot; or &quot;pony rides&quot; work much better."],
                        ["Do my stories have to be 100% original?",
                          "Yes. You can learn through imitation and inspiration, but this is about your work."],
                        ["Can my stories be based on real life incidents?",
                          "Yes, though you need to decide what level of discretion you will exercise. When it comes to creative nonfiction, some writers choose to change the names of those involved and not use last names, particularly for minors. Some writers get permission from people they write about, while others just write what they want to and worry about consequences later."],
                        ["Who owns the stories I post to Scrawlers?",
                          "You and you alone. If you feel someone is violating your work, contact us."],
                        ["Who owns the notes I post to Scrawlers?",
                          "You and you alone. If you feel someone is violating your work, contact us."]
                       ])
    populate_questions(FaqSection.find_by_title("Workshopping"),
                       [["Why should I have my story workshopped?",
                         "Scrawlers is about improving our writing. Having others read your work before the pressure of trying to publish it can be a first step in taking your story to the next level. Submit your work with an open mind, leave with several new opinions on your work, and rewrite accordingly."],
                        ["Why should I make notes on a story?",
                          "The workshopping process doesn't work if writers aren't willing to help each other out. Don't worry about ego &ndash; it's all about helping each other become better writers."],
                        ["How do I make notes on a story?",
                          "Click the link at the bottom of a story to make a note. Productive, helpful notes are always more appreciated than just bashing a story."],
                        ["How do I respond to notes on my story?",
                          "Click the link at the bottom of a story to respond to a note. Be careful of ending up playing defense, however &ndash; in theory, writers are giving you notes because they want you to improve your craft."],
                        ["When will my story be commented on?",
                          "As soon as a writer decides you have something worth commenting on, expect to see their thoughts crop up."],
                        ["Who reads my stories and notes?",
                          "Anyone can read your stories, but only registered Scrawlers users can respond to your story with notes."],
                        ["Whose notes on my stories should I listen to?",
                          "Chances are, you won&rsquo;t agree with each and every note you get on a story. However, we encourage you to read notes with an open mind. Perhaps read the notes, but don&rsquo;t come back to the story for a week or so. Then, take it all in with fresh eyes. Some of those comments you disagreed with may end up making sense."],
                        ["What if other writers just plain hate my story?",
                          "Well, that happens. It doesn&rsquo;t mean your story is complete rubbish, but then again, maybe it is. The more you use Scrawlers, the better handle you&rsquo;ll get on how to take notes, and what constitutes a good story. Remember &ndash; it&rsquo;s all about improving your writing."],
                        ["Can I just publish stories and not make notes?",
                          "Yyyyeah, but we don&rsquo;t encourage it. It definitely wouldn&rsquo;t give you the full experience of a workshop. There&rsquo;s nothing worse than entrusting your hard work to your peers, only to have no one read it. Besides, savvy writers will catch on that you&rsquo;re not commenting on anyone&rsquo;s stories, and they may decide to return you the favor."],
                        ["My story hasn&rsquo;t received any notes. What do I do?",
                          "First, be patient. All good things come to those who wait. Second, start giving notes. If writers find your notes helpful, they may be enticed to read your stories and give notes in kind. Community, folks. We can&rsquo;t stress this enough."],
                        ["What do I do with my story after it&rsquo;s been workshopped?",
                          "It&rsquo;s up to you. Toss it in a drawer. Try to get it published. Read it at open mic night. Print it off and use it as wrapping paper. Whatever you do, we hope you learned something that could help you improve your writing."]
                       ])
    populate_questions(FaqSection.find_by_title("Lists"),
                       [["How are the New Releases listed?",
                         "New Releases are listed in the order writers post them. This list can change within seconds."],
                        ["How is the Bestsellers list calculated?",
                          "Bestsellers are based on a formula crossing the number of votes a story receives with how high the story ratings are. The more high votes a story receives, the higher it appears on the Bestseller list."],
                        ["How is the Top Picks list calculated?",
                          "These are stories bookmarked as favorite stories by other writers in the community. If a story appears in Top Picks, the community must really enjoy it."],
                        ["Is Scrawlers just a popularity contest?",
                          "No, but like anything involving subjective opinion, Scrawlers writers use their own person criteria to rate stories. Write for yourself, but keep your audience in mind. Don&rsquo;t worry about writing the best story of all time &ndash; instead, take this opportunity to improve your writing."],
                        ["I think a group of writers is getting together to bash my story. What should I do?",
                          "Those jerks. Seriously, however, if you feel you are receiving abuse at Scrawlers, let us know and we will look into it."]
                       ])
    populate_questions(FaqSection.find_by_title("Creativity"),
                       [["Why 100 words? Isn&rsquo;t that too limiting?",
                         "It all depends on your point of view. Think of it as an exercise in both control and style. If inflated, overly long prose is your bane, then this may be the exercise you need to pare your words down to the bare essentials. You can always expand your story on your own later."],
                        ["What should I write about?",
                          "Anything you want, but understand what you post &ndash; both stories and notes &ndash; are out there for anyone to read. Scrawlers reserves the right to delete content it deems inappropriate, but you should still feel free to write your story."],
                        ["Does Scrawlers edit writer content?",
                          "We&rsquo;re not the babysitter, but we reserve the write to delete content deemed inappropriate on a case-by-case basis."],
                        ["Who determines what constitutes &ldquo;appropriate content?&rdquo;",
                          "Scrawlers staff."],
                        ["What are some tips / rules for good writing?",
                          "The validity of writing tips is subjective, of course, but consider questions like both in your own writing and what you&rsquo;re reading: What is the voice of the story? What are the stakes involved in this story? Is the story providing enough &ldquo;show&rdquo; over &ldquo;tell&rdquo;? What could be cut and the story would still make sense? What&rsquo;s not on the page that needs to be there? Who is the intended audience for this story? We&rsquo;re a fan of Elmore Leonard (Get Shorty, The Hot Kid), and his Ten Rules of Writing reads like a list of no-brainers."],
                        ["Where do writers get their ideas?",
                          "Everywhere. Anywhere. Your life. The newspaper. A memory. A &ldquo;what if&hellip;?&rdquo; scenario. A Scrawlers writing prompt. The good ideas will come, but always, always keep writing."]
                       ])
    populate_questions(FaqSection.find_by_title("Future"),
                       [["Will Scrawlers allow stories over 100 words in length, someday?",
                         "Mmmmmaybe. We&rsquo;ll see. If you behave."],
                        ["Will Scrawlers ever expand into other features, like more comprehensive profiles, message boards, IM, etc.?",
                          "We want to get the ball rolling first before we add too many bells and whistles. If writer demand calls for something grand, it just might find its way into Scrawlers. <a href='mailto:feedback@scrawlers.com'>Send us your ideas</a>."],
                        ["Can I meet fellow Scrawlers in-person?",
                          "We have no plans to set up in-person meets at this time. You do so at your own risk."],
                        ["Do Scrawlers staff attend writers&rsquo; programs / conferences?",
                          "Barry Hess and Nathan Melcher attend various business and writing conferences, but as attendees only; we will let you know if we&rsquo;re presenting anywhere. Nathan Melcher is a current Creative Writing MFA student at Minnesota State University &ndash; Mankato, MN."]
                       ])
    populate_questions(FaqSection.find_by_title("Academic Writing"),
                       [["Is Scrawlers affiliated with accredited writing programs?",
                         "No"],
                        ["Does Scrawlers recommend accredited writing programs?",
                          "No, but Nathan Melcher is currently a Creative Writing MFA student at Minnesota State University &ndash; Mankato, MN and enjoys it quite a bit."],
                        ["How does Scrawlers resemble / differ from a writing workshop at an accredited institution?",
                          "Workshops vary from instructor to instructor, but we have attempted to create the general &ldquo;present work, peers read it and comment&rdquo; sensibility common to many writing workshops. Written comments, without verbal face-to-face interaction, can work better or worse alone, depending on the person. If you want to check out a writing workshop, contact your local institution about auditing a class."],
                        ["How do I know I should pursue a degree in writing?",
                          "Creative Writing MFA programs around the country are growing, with more and more writers deciding it&rsquo;s time to hone their craft. Only you will know when you&rsquo;re ready, but remember: tomorrow&rsquo;s publishing market will be more competitive than ever, so plan ahead. (Extra bonus tip: most MFA program application deadlines for fall enrollment are in December-February, so definitely plan ahead for this!)"]
                       ])
    populate_questions(FaqSection.find_by_title("Professional Writing"),
                       [["Can Scrawlers get me an agent or book deal?",
                         "Sorry, but no. We are not directly affiliated, but a good place to start is <a href='http://www.writersmarket.com'>writersmarket.com</a>."],
                        ["How do I get an agent or a book deal?",
                          "Keep writing. Beyond that, there are other resources out there which can answer this question better than we."],
                        ["Do agents read Scrawlers and can they contact me?",
                          "If agents read your writing on Scrawlers and like it, they will let you know. NOTE: Be wary of anyone claiming to be an agent who will read your work for a &ldquo;reader&rsquo;s fee.&rdquo; These entities are likely out for a quick buck, not to get you published."],
                        ["Do professional writers ever publish at Scrawlers?",
                          "If they do, it is their business their business to reveal their identity, not ours."]
                       ])
    populate_questions(FaqSection.find_by_title("Miscellaneous"),
                       [["Do the Scrawlers founders think they have all the answers?",
                         "If they did, they&rsquo;d have more money by now. More money and more bling."],
                        ["What other projects from the Scrawlers founders are there?",
                          "Barry Hess maintains a business and personal blog at <a href='http://www.bjhess.com'>bjhess.com</a>. Nathan Melcher maintains his live performance calendar at <a href='http://www.caseous.com'>caseous.com</a>."],
                        ["Will Scrawlers be my baby&rsquo;s daddy?",
                          "No."]
                       ])
    
  end

  def self.down
    FaqSection.delete_all
    Question.delete_all
  end
  
  private
    def self.populate_subsection(section, subsection_titles)
      section.children = Array.new
      priority = 0
      subsection_titles.each do |title|
        faq_subsection = FaqSection.create(:title => title,
                                           :priority => priority += 1)
        section.children << faq_subsection
      end
      section.save!
    end
    
    def self.populate_questions(section, questions_and_answers)
      section.questions = Array.new
      priority = 0
      questions_and_answers.each do |question, answer|
        question = Question.create(:title => question,
                                   :answer => answer,
                                   :priority => priority += 1)
        section.questions << question
      end
      section.save
    end
end
