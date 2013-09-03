class Question
  def self.all
    results = QuestionsDatabase.instance.execute("SELECT * FROM questions")
    results.map { |result| Question.new(result) }
  end

  attr_accessor :id, :title, :body, :user_id

  def initialize(options = {})
    @id = options["id"]
    @title = options["title"]
    @body = options["body"]
    @user_id = options["user_id"]
  end

  def create
    raise "already saved!" unless self.id.nil?

    QuestionsDatabase.instance.execute(<<-SQL, title, body, user_id)
      INSERT INTO
        questions (title, body, user_id)
      VALUES
        (?, ?, ?)
    SQL

    @id = QuestionsDatabase.instance.last_insert_row_id
  end

  def self.find_by_id(search_id)
    results = QuestionsDatabase.instance.execute(<<-SQL, search_id)
      SELECT
        *
      FROM
        questions
      WHERE id = ?
    SQL
    Question.new(results.first)
  end


  def self.find_by_author_id(search_id)
    results = QuestionsDatabase.instance.execute(<<-SQL, search_id)
      SELECT
        *
      FROM
        questions
      WHERE user_id = ?
    SQL

    results.map { |result| Question.new(result) }
  end

  def author
    results = QuestionsDatabase.instance.execute(<<-SQL, user_id)
      SELECT
        *
      FROM
        users
      WHERE id = ?
    SQL

    results.map { |result| User.new(result) }
  end

  def replies
    results = QuestionsDatabase.instance.execute(<<-SQL, id)
      SELECT
        *
      FROM
        replies
      WHERE question_id = ?
    SQL

    results.map { |result| Reply.new(result) }
  end

  def followers
    QuestionFollower.followers_for_question_id(id)
  end

  def self.most_followed(n)
    QuestionFollower.most_followed_questions(n)
  end

  def likers
    QuestionLike.likers_for_question_id(id)
  end

  def num_likes
    QuestionLike.num_likes_for_question_id(id)
  end

  def self.most_liked(n)
    QuestionLike.most_liked_questions(n)
  end

end
