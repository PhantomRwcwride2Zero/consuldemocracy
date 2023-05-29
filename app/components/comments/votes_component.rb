class Comments::VotesComponent < ApplicationComponent
  attr_reader :comment
  delegate :can?, :current_user, to: :helpers

  def initialize(comment)
    @comment = comment
  end

  def pressed?(value)
    case current_user&.voted_as_when_voted_for(comment)
    when true
      value == "yes"
    when false
      value == "no"
    else
      false
    end
  end
end
