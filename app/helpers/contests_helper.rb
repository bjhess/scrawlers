module ContestsHelper
  def contest_winner_text(contest)
    first_place_story = contest.first_place_story
    return "to be determined." unless first_place_story
    winner            = first_place_story.user
    link_to(first_place_story.title, story_path(first_place_story)) +
      " by #{link_to(winner.display_name, user_path(winner))}"
  end
end
