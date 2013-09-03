class QuestionFollower < Database
  def self.all
    results = QuestionsDatabase.instance.execute("SELECT * FROM question_followers")
    results.map{ |result| QuestionFollower.new(result) }
  end

  attr_accessor :user_id, :question_id
  attr_reader :id

  def initialize(options = {})
    @id = options["id"]
    @user_id = options["user_id"]
    @question_id = options["question_id"]
  end

  def self.find_by_id(search_id)

    results = QuestionsDatabase.instance.execute(<<-SQL, search_id)
      SELECT
        *
      FROM
        question_followers
      WHERE id = ?
    SQL

    QuestionFollower.new(results.first)
  end

  def self.followers_for_question_id(search_id)
    results = QuestionsDatabase.instance.execute(<<-SQL, search_id)
      SELECT
        users.*
      FROM
        question_followers
      JOIN
        users
      ON
        users.id = user_id
      WHERE
        question_id = ?
    SQL

    results.map { |result| User.new(result) }
  end

  def self.followed_questions_for_user_id(search_id)
    results = QuestionsDatabase.instance.execute(<<-SQL, search_id)
      SELECT
        questions.*
      FROM
        question_followers JOIN questions
      ON
        questions.id = question_id
      WHERE
        question_followers.user_id = ?
    SQL

    results.map { |result| Question.new(result) }
  end

  def self.most_followed_questions(n)
    results = QuestionsDatabase.instance.execute(<<-SQL, n)
      SELECT
        questions.*
      FROM
        question_followers
      JOIN
        questions
      ON
        questions.id = question_id
      GROUP BY
        question_id
      ORDER BY
        COUNT(question_followers.user_id) DESC
      LIMIT ?
    SQL

    results.map { |result| Question.new(result) }
  end

end
