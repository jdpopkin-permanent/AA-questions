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
#rm questions.db
#cat import_db.sql | sqlite3 questions.db

# new_user = User.new({"fname" => "Joe", "lname" => "Biden"})
# new_user.create

# call user funcs
colin = User.find_by_name("Colin", "MacKenzie").first
jackson = User.find_by_name("Jackson", "Popkin").first
joe = User.find_by_name("Joe", "Biden").first
# p colin.authored_questions
# p jackson.authored_replies

#call q functions
q_lunch = Question.find_by_author_id(colin.id).first
# p q_lunch.author
# p q_lunch.replies

reply = Reply.find_by_question_id(q_lunch.id).first
reply2 = Reply.find_by_user_id(colin.id).first

joe.fname = "Joseph"
joe.save
new_joe = User.find_by_name("Joseph", "Biden").first
p new_joe

