class QuestionLike < Database
  def self.all
    results = QuestionsDatabase.instance.execute("SELECT * FROM question_likes")
    results.map{ |result| QuestionLike.new(result) }
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
        question_likes
      WHERE id = ?
    SQL

    QuestionLike.new(results.first)

  end

  def self.likers_for_question_id(question_id)
    results = QuestionsDatabase.instance.execute(<<-SQL, question_id)
      SELECT
        users.*
      FROM
        question_likes
      JOIN
        users
      ON
        users.id = user_id
      WHERE
        question_id = ?
    SQL

    results.map { |result| User.new(result) }
  end

  def self.num_likes_for_question_id(question_id)
    results = QuestionsDatabase.instance.execute(<<-SQL, question_id)
      SELECT
        COUNT(user_id)
      FROM
        question_likes
      WHERE
        question_id = ?
    SQL

    results[0].values[0]
  end

  def self.liked_questions_for_user_id(user_id)
    results = QuestionsDatabase.instance.execute(<<-SQL, user_id)
      SELECT
        questions.*
      FROM
        question_likes
      JOIN
        questions
      ON
        questions.id = question_id
      WHERE
        question_likes.user_id = ?
    SQL

    results.map { |result| Question.new(result) }
  end

  def self.most_liked_questions(n)
    results = QuestionsDatabase.instance.execute(<<-SQL, n)
      SELECT
        questions.*
      FROM
        question_likes
      JOIN
        questions
      ON
        questions.id = question_id
      GROUP BY
        question_id
      ORDER BY
        COUNT(question_likes.user_id) DESC
      LIMIT ?
    SQL

    results.map { |result| Question.new(result) }
  end
end
