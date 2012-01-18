class UpdatePrivacyPolicyInFaq < ActiveRecord::Migration
  def self.up
    question = Question.find_by_title("What is the Scrawlers privacy policy?")
    question.update_attribute(:answer,
                                  "We will never sell your information to anyone, period. We will never share your email address with a third party, period.")
  end

  def self.down
    question = Question.find_by_title("What is the Scrawlers privacy policy?")
    question.update_attribute(:answer,
                                  "We will never sell your information to anyone, period. We will only send you the email you tell us you want, period.")
  end
end
