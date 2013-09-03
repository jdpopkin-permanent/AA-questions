require 'singleton'
require 'sqlite3'
require_relative 'database'
require_relative 'user'
require_relative 'question'
require_relative 'questionfollower'
require_relative 'reply'
require_relative 'questionlike'
require_relative 'tag'

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

colin = User.find_by_name("Colin", "MacKenzie").first
jackson = User.find_by_name("Jackson", "Popkin").first
joe = User.find_by_name("Joe", "Biden").first

q_lunch = Question.find_by_author_id(colin.id).first

reply = Reply.find_by_question_id(q_lunch.id).first
reply2 = Reply.find_by_user_id(colin.id).first

temp_tag = Tag.find_by_id(2)
temp_tag.most_popular
#most_popular
joe.fname = "Joseph"
joe.save
p User.find_by_name("Joseph", "Biden")