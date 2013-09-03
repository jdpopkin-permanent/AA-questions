class User < Database
  #@@database = "users"
  def self.all
    results = QuestionsDatabase.instance.execute("SELECT * FROM users")
    results.map{ |result| Users.new(result) }
  end

  attr_accessor :fname, :lname
  attr_reader :id

  def initialize(options = {})
    @id = options["id"]
    @database = "users"
    @fname = options["fname"]
    @lname = options["lname"]
  end

  def self.find_by_id(search_id)

    results = QuestionsDatabase.instance.execute(<<-SQL, search_id)
      SELECT
        *
      FROM
        users
      WHERE id = ?
    SQL

    User.new(results.first)

  end

  def self.find_by_name(fname, lname)
    results = QuestionsDatabase.instance.execute(<<-SQL, fname, lname)
      SELECT
        *
      FROM
        users
      WHERE fname = ? AND lname = ?
    SQL

    results.map { |result| User.new(result) }
  end

  def authored_questions
    results = QuestionsDatabase.instance.execute(<<-SQL, self.id)
      SELECT
        *
      FROM
        questions
      WHERE user_id = ?
    SQL

    results.map { |result| Question.new(result) }
  end

  def authored_replies
    results = QuestionsDatabase.instance.execute(<<-SQL, self.id)
      SELECT
        *
      FROM
        replies
      WHERE user_id = ?
    SQL

    results.map { |result| Reply.new(result) }
  end

  def followed_questions
    QuestionFollower.followed_questions_for_user_id(id)
  end

  def liked_questions
    QuestionLike.liked_questions_for_user_id(id)
  end

  def average_karma
    results = QuestionsDatabase.instance.execute(<<-SQL, self.id)
      SELECT
        COUNT(question_likes.user_id) / CAST(COUNT(DISTINCT questions.id) AS FLOAT)
      FROM
        questions
      LEFT OUTER JOIN
        question_likes
      ON
        question_likes.question_id = questions.id
      JOIN
        users
      ON
        questions.user_id = users.id
      WHERE
        questions.user_id = ?
    SQL

    results[0].values[0]
  end
end
