class Database

  def save
    if self.id.nil?
      self.create

    else
      arr_instance = self.instance_variables[2..-1]
      arr_values = arr_instance.map { |var| instance_variable_get(var).to_s }
      arr_instance = arr_instance.map{ |var| var.to_s[1..-1] }

      str_to_insert = arr_instance.join(" = ?, ")
      str_to_insert += " = ?"

      execute_string = (<<-SQL)
        UPDATE
          #{@database}
        SET
          #{str_to_insert}
        WHERE
          id = ?
      SQL

      QuestionsDatabase.instance.execute(execute_string, arr_values + [self.id])
    end
  end

  def create
    raise "already saved!" unless self.id.nil?

    arr_instance = self.instance_variables[2..-1]
    arr_values = arr_instance.map { |var| instance_variable_get(var).to_s }
    arr_instance = arr_instance.map{ |var| var.to_s[1..-1] }

    str_to_insert = "(" + arr_instance.join(", ") + ")"
    question_mark_string = "("
    arr_values.length.times { question_mark_string += "?, " }
    question_mark_string = question_mark_string[0...-2] + ")"

    execute_string = (<<-SQL)
      INSERT INTO
        #{@database} #{str_to_insert}
      VALUES
        #{question_mark_string}
    SQL

    QuestionsDatabase.instance.execute(execute_string, arr_values)

    @id = QuestionsDatabase.instance.last_insert_row_id
  end
end