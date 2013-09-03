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
end