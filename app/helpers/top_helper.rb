# frozen_string_literal: true

module TopHelper
  def mr_or_ms?
    if current_member.sex == 1
      'Mr.'
    elsif current_member.sex == 2
      'Ms.'
    else
      ''
    end
  end
end
