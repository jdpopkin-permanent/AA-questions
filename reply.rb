class Reply
  def self.all
    results = QuestionsDatabase.instance.execute("SELECT * FROM replies")
    results.map{ |result| Reply.new(result) }
  end

  attr_accessor :id, :reply, :question_id, :reply_id, :user_id

  def initialize(options = {})
    @id = options["id"]
    @reply = options["reply"]
    @question_id = options["question_id"]
    @reply_id = options["reply_id"]
    @user_id = options["user_id"]
  end

  def create
    raise "already saved!" unless self.id.nil?

    QuestionsDatabase.instance.execute(<<-SQL, reply, question_id, reply_id, user_id)
      INSERT INTO
        replies (reply, question_id, reply_id, user_id)
      VALUES
        (?, ?, ?, ?)
    SQL

    @id = QuestionsDatabase.instance.last_insert_row_id
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
end