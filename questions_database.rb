require 'singleton'
require 'sqlite3'
require_relative 'user'
require_relative 'question'
require_relative 'questionfollower'
require_relative 'reply'
require_relative 'questionlike'

class QuestionsDatabase < SQLite3::Database
  include Singleton

  def initialize
    super("questions.db")
    self.results_as_hash = true
    self.type_translation = true
  end
end

class Reply

end

class QuestionLike

end

# new_user = User.new({"fname" => "Joe", "lname" => "Biden"})
# new_user.create
# p User.find_by_id(new_user.id)
# p User.find_by_id(1)
# p User.find_by_id(2)

# call user funcs
colin = User.find_by_name("Colin", "MacKenzie").first
jackson = User.find_by_name("Jackson", "Popkin").first
# p colin.authored_questions
# p jackson.authored_replies

#call q functions
q_lunch = Question.find_by_author_id(colin.id).first
p q_lunch.author
p q_lunch.replies
