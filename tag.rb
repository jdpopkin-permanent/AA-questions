class Tag
  def self.all
    results = QuestionsDatabase.instance.execute("SELECT * FROM tags")
    results.map{ |result| Tag.new(result) }
  end

  attr_accessor :tag_name
  attr_reader :id

  def initialize(options = {})
    @id = options["id"]
    @tag_name = options["tag_name"]
  end

  def self.find_by_id(search_id)

    results = QuestionsDatabase.instance.execute(<<-SQL, search_id)
      SELECT
        *
      FROM
        tags
      WHERE id = ?
    SQL
    Tag.new(results.first)

  end

  def most_popular
    results = QuestionsDatabase.instance.execute(<<-SQL, self.id)

      SELECT
        sub_q.*
      FROM (
        SELECT
          questions.*
        FROM
          questions
        JOIN
          question_tags
        ON
          question_tags.question_id = questions.id
        WHERE
          tag_id = ?) AS sub_q
      JOIN
        question_likes
      ON
        sub_q.id = question_likes.question_id
      GROUP BY
        question_id
      ORDER BY
        COUNT(question_likes.user_id) DESC
      LIMIT 1

      SQL

    results
  end
end