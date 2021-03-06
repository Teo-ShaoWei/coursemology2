# frozen_string_literal: true
class Course::Assessment::Question::VoiceResponse < ApplicationRecord
  acts_as :question, class_name: Course::Assessment::Question.name

  def attempt(submission, last_attempt = nil)
    answer =
      Course::Assessment::Answer::VoiceResponse.new(submission: submission, question: question)
    answer.attachment_reference = last_attempt.attachment_reference.dup if last_attempt&.attachment_reference

    answer.acting_as
  end

  def initialize_duplicate(duplicator, other)
    copy_attributes(other)
    associate_duplicated_skills(duplicator, other)
  end
end
