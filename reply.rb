class Reply < Database
  def self.all
    results = QuestionsDatabase.instance.execute("SELECT * FROM replies")
    results.map{ |result| Reply.new(result) }
  end

  attr_accessor :reply, :question_id, :reply_id, :user_id
  attr_reader :id

  def initialize(options = {})
    @id = options["id"]
    @database = "replies"
    @reply = options["reply"]
    @question_id = options["question_id"]
    @reply_id = options["reply_id"]
    @user_id = options["user_id"]
  end

  def self.find_by_id(search_id)

    results = QuestionsDatabase.instance.execute(<<-SQL, search_id)
      SELECT
        *
      FROM
        replies
      WHERE id = ?
    SQL

    Reply.new(results.first)
  end

  def self.find_by_question_id(searched_id)
    results = QuestionsDatabase.instance.execute(<<-SQL, searched_id)
      SELECT
        *
      FROM
        replies
      WHERE question_id = ?
    SQL

    results.map { |result| Reply.new(result) }
  end

  def self.find_by_user_id(searched_id)
    results = QuestionsDatabase.instance.execute(<<-SQL, searched_id)
      SELECT
        *
      FROM
        replies
      WHERE user_id = ?
    SQL

    results.map { |result| Reply.new(result) }
  end

  def author
    results = QuestionsDatabase.instance.execute(<<-SQL, user_id)
      SELECT
        *
      FROM
        users
      WHERE
        id = ?
    SQL

    results.map { |result| User.new(result) }
  end

  def question
    results = QuestionsDatabase.instance.execute(<<-SQL, question_id)
      SELECT
        *
      FROM
        questions
      WHERE
        id = ?
    SQL

    results.map { |result| Question.new(result) }
  end

  def parent_reply
    results = QuestionsDatabase.instance.execute(<<-SQL, reply_id)
      SELECT
        *
      FROM
        replies
      WHERE
        id = ?
    SQL

    results.map { |result| Reply.new(result) }
  end

  def child_replies
    results = QuestionsDatabase.instance.execute(<<-SQL, id)
      SELECT
        *
      FROM
        replies
      WHERE
        reply_id = ?
    SQL

    results.map { |result| Reply.new(result) }
  end

  private
  def create
    raise "already saved!" unless self.id.nil?

    QuestionsDatabase.instance.execute(<<-SQL, reply, question_id, reply_id, user_id)
      INSERT INTO
        replies (reply, question_id, reply_id, user_id)
      VALUES
        (?, ?2, ?3, ?4)
    SQL

    @id = QuestionsDatabase.instance.last_insert_row_id
  end

end